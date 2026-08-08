# Detailed System Design

## Status and scope

This document visualizes the target production architecture. Components enter
the repository incrementally according to the [roadmap](../../ROADMAP.md); the
diagram is not a statement that every service exists today.

## Container architecture

```mermaid
flowchart TB
    subgraph Clients["Clients"]
        Portal["React developer portal"]
        CLI["Go CLI"]
        PySDK["Python SDK"]
        GoSDK["Go SDK"]
        TSClient["TypeScript API client"]
    end

    subgraph ControlPlane["Go control plane"]
        Gateway["REST API and authentication"]
        Resource["Project, agent, model, and tool services"]
        Workflow["Workflow and run coordinator"]
        Policy["Policy and approval service"]
        Scheduler["Scheduler"]
        Projector["Event and usage projectors"]
        Outbox["Outbox publishers"]
    end

    subgraph ExecutionPlane["Python execution plane"]
        Dispatcher["Worker dispatcher"]
        Runtime["Agent runtime"]
        ModelRouter["Model router and fallback"]
        ToolRuntime["Tool and MCP runtime"]
        Retrieval["Retrieval pipeline"]
    end

    subgraph State["Durable and operational state"]
        Postgres[("PostgreSQL and pgvector")]
        NATS[("NATS JetStream")]
        Redis[("Redis ephemeral coordination")]
    end

    subgraph External["External systems"]
        Models["Model providers"]
        MCP["MCP servers"]
        Data["APIs, repositories, and knowledge sources"]
        IdP["External identity provider"]
    end

    subgraph Operations["Operations"]
        OTel["OpenTelemetry collector"]
        Backends["Trace, metric, and log backends"]
    end

    Portal --> Gateway
    CLI --> Gateway
    PySDK --> Gateway
    GoSDK --> Gateway
    TSClient --> Gateway
    IdP --> Gateway
    Gateway --> Resource
    Gateway --> Workflow
    Gateway --> Policy
    Scheduler --> Workflow
    Resource --> Postgres
    Workflow --> Postgres
    Policy --> Postgres
    Outbox --> Postgres
    Outbox --> NATS
    NATS --> Dispatcher
    Dispatcher --> Runtime
    Runtime --> ModelRouter
    Runtime --> ToolRuntime
    Runtime --> Retrieval
    ModelRouter --> Models
    ToolRuntime --> MCP
    Retrieval --> Data
    Retrieval --> Postgres
    Projector --> NATS
    Projector --> Postgres
    Workflow -.->|short-lived coordination| Redis
    Gateway --> OTel
    Workflow --> OTel
    Runtime --> OTel
    OTel --> Backends
```

## Data ownership and access

```mermaid
flowchart LR
    Projects["Project and identity domain"] --> PG1[("PostgreSQL")]
    Catalog["Agent, workflow, model, and tool catalog"] --> PG1
    Runs["Runs, node attempts, events, and approvals"] --> PG1
    Usage["Usage and evaluation projections"] --> PG1
    Knowledge["Embeddings and retrieval metadata"] --> Vector[("pgvector initially")]
    Dispatch["Commands and distributed events"] --> NATS[("NATS JetStream")]
    Cache["Rate limits, leases, and cache"] --> Redis[("Redis")]
    Secrets["Encrypted secret material"] --> SecretStore[("Secret store or encrypted columns")]

    PG1 -. "system of record" .-> Rebuild["Rebuildable projections"]
    NATS -. "delivery, not canonical state" .-> Rebuild
    Redis -. "never durable truth" .-> Rebuild
```

| Data class | Owner | Consistency requirement | Retention |
| --- | --- | --- | --- |
| Projects and published definitions | Control plane | Transactional and strongly consistent | Until explicitly deleted |
| Runs, approvals, and audit metadata | Control plane | Durable and append-oriented | Operator policy |
| Execution commands and events | Producer plus stream | At-least-once delivery | Bounded stream policy |
| Trace, metric, and log signals | Observability pipeline | Best effort with visible loss | Backend policy |
| Cache, lease, and rate-limit state | Owning service | Reconstructable | Short-lived |
| Credentials | Credential service | Encrypted, scoped, and auditable | Rotation policy |

## Protocol and trust-boundary map

```mermaid
flowchart TB
    Internet["User or application network"] -->|"HTTPS and OIDC"| Edge["Ingress and API boundary"]
    Edge -->|"Versioned REST"| API["Control-plane API"]
    API -->|"TLS database protocol"| PG[("PostgreSQL")]
    API -->|"Authenticated messaging"| NATS[("NATS JetStream")]
    NATS -->|"Scoped worker identity"| Worker["Runtime worker"]
    Worker -->|"Provider HTTPS"| Model["Model provider"]
    Worker -->|"Approved MCP transport"| MCP["MCP server"]
    Worker -->|"Controlled egress"| Sources["Knowledge sources"]
    API -->|"OTLP"| Collector["Telemetry collector"]
    Worker -->|"OTLP"| Collector
```

Every solid edge crosses a contract boundary. Authentication, authorization,
schema validation, timeouts, redaction, and telemetry are applied at the edge
appropriate to that protocol.

## Production deployment topology

```mermaid
flowchart TB
    Internet["Users and applications"] --> LB["TLS ingress or load balancer"]

    subgraph Cluster["Kubernetes cluster"]
        LB --> API1["Control plane replica A"]
        LB --> API2["Control plane replica B"]
        Portal["Portal replicas"] --> LB
        Scheduler["Leader-elected schedulers"]
        WorkerA["General runtime workers"]
        WorkerB["Isolated high-risk workers"]
        Collector["OpenTelemetry collector"]

        API1 --> Scheduler
        API2 --> Scheduler
        WorkerA --> Collector
        WorkerB --> Collector
        API1 --> Collector
        API2 --> Collector
    end

    API1 --> PG[("Highly available PostgreSQL")]
    API2 --> PG
    Scheduler --> NATS[("NATS JetStream cluster")]
    NATS --> WorkerA
    NATS --> WorkerB
    API1 --> Redis[("Redis")]
    API2 --> Redis
    Collector --> Telemetry["Operator-selected telemetry backends"]
    WorkerA --> External["Models, MCP, and data services"]
    WorkerB --> External
```

Stateful dependencies may run inside or outside the cluster. Helm values must
support externally managed PostgreSQL, NATS, Redis, secret management, and
telemetry backends.

## High-availability and recovery flow

```mermaid
flowchart TD
    Fault["Instance, worker, or dependency failure"] --> Detect["Health checks, lease expiry, or delivery timeout"]
    Detect --> Kind{"Failure location"}
    Kind -->|Stateless API| Route["Ingress routes to healthy replica"]
    Kind -->|Worker| Redeliver["Broker redelivers unacknowledged work"]
    Kind -->|Scheduler leader| Elect["Another scheduler acquires leadership"]
    Kind -->|PostgreSQL| Pause["Fail closed and pause state-changing work"]
    Kind -->|External provider| Policy["Apply bounded retry or allowed fallback"]
    Redeliver --> Dedupe["Idempotent claim prevents duplicate effects"]
    Elect --> Reconcile["Reconcile due schedules from durable state"]
    Pause --> Recover["Restore connectivity and reconcile outbox"]
    Policy --> Record["Record attempt, error, and selected outcome"]
```

## End-to-end execution flow

```mermaid
sequenceDiagram
    autonumber
    actor User
    participant Portal
    participant API as Control plane
    participant DB as PostgreSQL
    participant Stream as NATS JetStream
    participant Worker as Runtime worker
    participant Model
    participant MCP as MCP tool server
    participant OTel as Telemetry pipeline

    User->>Portal: Select immutable agent version and submit input
    Portal->>API: Create run with idempotency key
    API->>DB: Persist run and dispatch outbox
    API-->>Portal: Return pending run
    API->>Stream: Publish from durable outbox
    Stream->>Worker: Deliver execution command
    Worker->>OTel: Start run and agent spans
    Worker->>Model: Model request with available tool schemas
    Model-->>Worker: Tool call request
    Worker->>API: Evaluate policy if centralized decision is needed
    API-->>Worker: Allow, deny, or require approval
    Worker->>MCP: Invoke allowed tool with scoped credential
    MCP-->>Worker: Tool result
    Worker->>Model: Continue with normalized tool result
    Model-->>Worker: Final output and usage
    Worker->>Stream: Publish terminal execution event
    API->>DB: Project status, usage, and trace reference
    Portal->>API: Read completed run
    API-->>Portal: Output, timeline, cost, and diagnostics
```

## Related documents

- [Architecture Overview](overview.md)
- [User and Operator Flows](user-flows.md)
- [Security Model](security-model.md)
- [Observability](observability.md)
