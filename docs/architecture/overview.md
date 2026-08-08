# Architecture Overview

## Status

Target architecture. The repository is currently in its initialization phase;
implementation proceeds incrementally according to the
[roadmap](../../ROADMAP.md).

The full diagram is a destination, not an instruction to instantiate every
plane now. The [Architecture Delivery Path](implementation-path.md) defines the
smallest approved implementation sequence and evidence gates.

## Purpose

Corex AgentOS is an operational layer for defining, executing, governing,
observing, and evaluating AI agents. It separates management concerns from the
code that performs model and tool execution so each can evolve independently.

The architecture optimizes for:

- provider-independent agent and model contracts;
- reliable, inspectable execution;
- explicit permissions and human approval;
- immutable definitions for reproducible runs;
- local development before distributed infrastructure;
- self-hosting with portable, open interfaces.

## Delivery architecture rule

```mermaid
flowchart LR
    First["One provider"] --> Second["One read-only tool"]
    Second --> Third["One model-tool-model loop"]
    Third --> Fourth["One complete trace"]
    Fourth --> Reliable["Reliability and contract tests"]
    Reliable --> Evidence["Repeat design-partner use"]
    Evidence --> Control["Smallest useful control plane"]
    Control --> Workflow["Smallest durable flagship workflow"]
    Workflow --> Scale["Governance, integrations, and distribution when evidenced"]
```

No future plane should become an early infrastructure dependency. v0.1 runs in
one Python process without PostgreSQL, NATS, Redis, Kubernetes, or a Go control
plane, while preserving interfaces that allow those planes to be added later.

## High-level platform components and interactions

```mermaid
flowchart TB
    subgraph Users["Users and client applications"]
        People["Developers, operators, approvers, and auditors"]
        Apps["AI-enabled products and internal applications"]
    end

    subgraph Experience["Experience plane"]
        Portal["Developer portal"]
        CLI["Corex CLI"]
        SDK["Python, Go, and TypeScript SDKs"]
    end

    subgraph Edge["API and edge plane"]
        API["Versioned REST API"]
        Webhooks["Signed webhooks and event streams"]
    end

    subgraph Identity["Authentication and identity plane"]
        IdP["Local identity, API keys, OIDC, and SSO"]
        AuthN["Authentication and session validation"]
        AuthZ["RBAC, project scope, and service identity"]
    end

    subgraph Control["Go control plane"]
        Catalog["Projects, agents, models, tools, and versions"]
        RunAPI["Run lifecycle and resource APIs"]
    end

    subgraph Security["Security and governance plane"]
        Governance["Policy, approval, budgets, and guardrails"]
        Credentials["Credential brokering and audit"]
    end

    subgraph Workflow["Workflow plane"]
        Definition["Workflow definition and validation"]
        Scheduler["Schedules, DAG coordination, and durable state"]
        Dispatcher["Node dispatch, retry, pause, and recovery"]
    end

    subgraph Execution["Python execution plane"]
        Workers["Runtime workers"]
        Agent["Agent and model loop"]
        ToolRuntime["Tool, MCP, and retrieval runtime"]
    end

    subgraph Integration["Integration plane"]
        Models["Model providers"]
        MCP["MCP servers and business tools"]
        Knowledge["Documents, APIs, databases, and data sources"]
    end

    subgraph Data["Data plane"]
        Postgres[("PostgreSQL")]
        Vector[("pgvector and future vector stores")]
        Events[("NATS JetStream")]
        Redis[("Redis ephemeral coordination")]
        Secrets["Encrypted secret storage"]
        Artifacts["Artifact and object storage"]
    end

    subgraph Observability["Observability and evaluation plane"]
        OTel["OpenTelemetry collection"]
        Telemetry["Traces, metrics, and logs"]
        Usage["Usage, cost, evaluations, and run explorer"]
    end

    subgraph GitOps["GitOps and delivery plane"]
        Git["Source, schemas, policy, and deployment configuration"]
        CI["Test, scan, build, sign, and publish"]
        Reconcile["Environment reconciliation, migration, and rollback"]
    end

    People --> Portal
    People --> CLI
    Apps --> SDK
    Portal --> API
    CLI --> API
    SDK --> API
    API --> AuthN
    AuthN --> IdP
    AuthN --> AuthZ
    AuthZ --> Catalog
    AuthZ --> Governance
    AuthZ --> RunAPI
    API --> Catalog
    API --> Governance
    API --> RunAPI
    Catalog --> Postgres
    Governance --> Postgres
    Governance --> Credentials
    Credentials --> Secrets
    RunAPI --> Definition
    Definition --> Scheduler
    Scheduler --> Postgres
    Scheduler --> Redis
    Scheduler --> Dispatcher
    Dispatcher -->|Dispatch work| Events
    Events --> Workers
    Workers --> Agent
    Agent --> Models
    Agent --> ToolRuntime
    ToolRuntime --> MCP
    ToolRuntime --> Knowledge
    ToolRuntime --> Vector
    Workers --> Governance
    Workers --> Artifacts
    Workers -->|Execution events| Events
    Events --> RunAPI
    API --> Telemetry
    Workers --> OTel
    Events --> OTel
    OTel --> Telemetry
    Events --> Usage
    Telemetry --> Usage
    Usage --> Portal
    RunAPI --> Webhooks
    Webhooks --> Apps
    Git --> CI
    CI --> Reconcile
    Reconcile -.-> Experience
    Reconcile -.-> Identity
    Reconcile -.-> Control
    Reconcile -.-> Security
    Reconcile -.-> Workflow
    Reconcile -.-> Execution
    Reconcile -.-> Observability
```

At a high level, users and applications access Corex through the portal, CLI,
SDKs, or REST API. The authentication plane establishes identity and scope. The
control and workflow planes manage durable definitions, governance, schedules,
and run coordination. Runtime workers execute agents against approved models,
tools, and knowledge sources through the integration plane. The data plane
holds durable and operational state. Execution events feed observability,
usage, and evaluation views, while the GitOps plane validates and reconciles
versioned platform changes.

## Major components

### Control plane

The Go control plane owns resource APIs and durable management state. It
validates agent and workflow definitions, resolves immutable versions,
dispatches execution work, enforces control-plane authorization, and exposes
run state to clients. See [Control Plane](control-plane.md).

### Agent runtime

The Python runtime executes agents. It owns the model/tool loop, runtime
timeouts and cancellation, provider adapters, tool invocation, and detailed
execution telemetry. It does not own durable project configuration. See
[Agent Runtime](runtime.md).

### Workflow engine

The workflow engine coordinates versioned directed acyclic graphs of agent,
tool, conditional, and approval nodes. The control plane owns durable workflow
state; workers perform node execution. See
[Workflow Engine](workflow-engine.md).

### Portal, CLI, and SDKs

Clients consume versioned public APIs. They must not connect directly to
control-plane databases or rely on internal event subjects. Shared clients live
under `packages/`; deployable applications live under `apps/`.

### External systems

Model providers, MCP servers, data sources, and observability backends are
outside the platform trust boundary. Adapters translate their behavior into
stable Corex contracts and normalize errors, usage, and telemetry.

## Logical planes

```mermaid
flowchart TB
    subgraph Experience["Experience plane"]
        Portal["Developer portal"]
        CLI["Corex CLI"]
        SDKs["Python, Go, and TypeScript SDKs"]
    end
    subgraph Management["Management plane"]
        API["Versioned REST API"]
        Catalog["Projects, agents, workflows, and tools"]
        Governance["Policy, approval, credentials, and audit"]
        Scheduler["Run and schedule coordination"]
    end
    subgraph Execution["Execution plane"]
        Dispatcher["Execution dispatcher"]
        Workers["Python runtime workers"]
        Engine["Agent and workflow execution"]
    end
    subgraph Integration["Integration plane"]
        Models["Model providers"]
        MCP["MCP servers"]
        Knowledge["Knowledge and vector stores"]
    end
    subgraph Operations["Operations plane"]
        Events["Event delivery"]
        Telemetry["Traces, metrics, and logs"]
        Eval["Evaluation and usage analytics"]
    end

    Portal --> API
    CLI --> API
    SDKs --> API
    API --> Catalog
    API --> Governance
    API --> Scheduler
    Scheduler --> Dispatcher
    Dispatcher --> Workers
    Workers --> Engine
    Engine --> Models
    Engine --> MCP
    Engine --> Knowledge
    Catalog --> Events
    Governance --> Events
    Engine --> Events
    Events --> Telemetry
    Events --> Eval
```

## Control and data flow

A typical run follows this sequence:

1. A client submits a run against an immutable agent or workflow version.
2. The control plane authenticates the caller, checks project scope, validates
   the request, and creates the durable run record.
3. Execution is dispatched locally in early releases and through NATS
   JetStream when distributed workers are introduced.
4. A runtime worker executes model and tool operations while emitting
   structured events and telemetry.
5. The control plane projects events into queryable run state and usage data.
6. Clients observe progress through APIs and inspect the complete trace after
   completion.

Sensitive actions add a policy decision and, when required, a durable approval
pause before execution continues.

## Source-of-truth rules

- PostgreSQL is the durable source of truth for platform resources and run
  state once persistence is introduced.
- NATS JetStream carries distributed work and events; it is not the canonical
  resource database.
- Redis may support ephemeral coordination, caching, and rate limits; it must
  not own durable platform state.
- Tracing backends provide operational views but do not replace durable run
  records.
- Every run references immutable agent and workflow versions.

## Contract boundaries

Public REST APIs, workflow and policy schemas, SDK interfaces, and the event
envelope are versioned contracts. Internal packages may evolve more quickly but
must not leak into public clients. Go/Python communication uses explicit
schemas rather than language-specific object serialization.

See [Event Model](event-model.md) for asynchronous contracts and
[ADR-0004](../adr/0004-mcp-first-tools.md) for external tool integration.

## Deployment evolution

The architecture expands only when a release requires it:

- v0.1 runs a Python agent locally and captures a complete trace.
- v0.2 adds the Go control plane, PostgreSQL, and portal-backed management.
- v0.3 adds durable workflows.
- v0.4 makes MCP and knowledge sources first-class.
- v0.5 adds policies, approvals, budgets, and evaluations.
- v0.6 introduces NATS JetStream and distributed workers.
- v1.0 packages the production system for self-hosted Kubernetes operation.

This sequence is intentional: module boundaries are established early, while
network boundaries are introduced only when scale or reliability demands them.

```mermaid
flowchart LR
    Local["v0.1: local SDK and runtime"] --> Managed["v0.2-v0.5: control plane and durable state"]
    Managed --> Distributed["v0.6-v0.9: broker and worker pools"]
    Distributed --> Production["v1.0: highly available self-hosted platform"]
```

## Related documents

- [Architecture Delivery Path](implementation-path.md)
- [Platform Planes and Modules](platform-planes.md)
- [Control Plane](control-plane.md)
- [Detailed System Design](system-design.md)
- [User and Operator Flows](user-flows.md)
- [Agent Runtime](runtime.md)
- [Workflow Engine](workflow-engine.md)
- [Security Model](security-model.md)
- [Observability](observability.md)
