# User and Operator Flows

## Status and actors

These flows describe the intended product experience across roadmap releases.
Screens and APIs shown here may not exist during repository initialization.

Primary actors are:

- **Agent developer:** defines agents, tools, and workflows and runs them.
- **Reviewer or approver:** authorizes sensitive actions.
- **Operator:** deploys the platform and diagnoses reliability problems.
- **Application:** invokes published agents through an SDK or API.

## Flow 1: local agent development

```mermaid
flowchart LR
    Install["Install Python SDK"] --> Define["Define agent instructions and output schema"]
    Define --> Model["Configure model adapter"]
    Model --> Tools["Register least-privilege tools"]
    Tools --> Run["Execute locally"]
    Run --> Inspect["Inspect events, tokens, latency, and cost"]
    Inspect --> Outcome{"Expected behavior?"}
    Outcome -- No --> Refine["Refine definition or tests"]
    Refine --> Run
    Outcome -- Yes --> Publish["Publish immutable version when control plane is available"]
```

## Flow 2: publish and run through the portal

```mermaid
sequenceDiagram
    autonumber
    actor Developer
    participant Portal
    participant API as Control plane
    participant Catalog as Version catalog
    participant Runtime
    participant Explorer as Run explorer

    Developer->>Portal: Create or edit an agent draft
    Portal->>API: Validate definition
    API-->>Portal: Validation result
    Developer->>Portal: Publish version
    Portal->>Catalog: Create immutable agent version
    Catalog-->>Portal: Version ID and configuration digest
    Developer->>Portal: Run version with input
    Portal->>API: Create run
    API->>Runtime: Dispatch resolved version
    Runtime-->>API: Stream lifecycle events
    API-->>Explorer: Update timeline and usage
    Developer->>Explorer: Inspect output and execution trace
```

## Flow 3: sensitive action approval

```mermaid
flowchart TD
    Request["Agent requests side-effecting tool"] --> Evaluate["Policy evaluates actor, tool, resource, and arguments"]
    Evaluate --> Decision{"Policy effect"}
    Decision -- Allow --> Execute["Execute with scoped credential"]
    Decision -- Deny --> Denied["Return policy denial and audit record"]
    Decision -- Require approval --> Pause["Durably pause run"]
    Pause --> Notify["Notify authorized approver"]
    Notify --> Review["Review exact arguments, risk, and reason"]
    Review --> Human{"Human decision"}
    Human -- Reject --> Rejected["Persist rejection and follow failure path"]
    Human -- Approve --> Revalidate["Revalidate version, arguments, expiry, and authority"]
    Revalidate --> Valid{"Still valid?"}
    Valid -- No --> Expire["Expire approval and request a new decision"]
    Valid -- Yes --> Execute
    Execute --> Audit["Record outcome in run trace and audit log"]
```

## Flow 4: build and execute a workflow

```mermaid
flowchart LR
    Draft["Draft workflow DAG"] --> Validate["Validate schema, references, and acyclic graph"]
    Validate --> Valid{"Valid?"}
    Valid -- No --> Errors["Show node-level validation errors"]
    Errors --> Draft
    Valid -- Yes --> Version["Publish immutable workflow version"]
    Version --> Start["Start manual or scheduled run"]
    Start --> Parallel["Execute ready nodes within concurrency limits"]
    Parallel --> Wait["Pause for dependencies or approvals"]
    Wait --> Parallel
    Parallel --> Complete["Produce workflow output"]
    Complete --> Inspect["Inspect DAG status, attempts, and trace"]
```

## Flow 5: diagnose a failed run

```mermaid
flowchart TD
    Alert["User sees failed or degraded run"] --> Summary["Open run summary"]
    Summary --> Timeline["Locate first failing node or operation"]
    Timeline --> Trace["Inspect trace span, normalized error, and retry history"]
    Trace --> Category{"Failure category"}
    Category -->|Agent or prompt behavior| Compare["Compare versions, output, tokens, and evaluations"]
    Category -->|Model provider| Provider["Inspect latency, status, usage, and fallback decision"]
    Category -->|Tool or MCP| Tool["Inspect schema-safe arguments, result, timeout, and permission"]
    Category -->|Platform| Platform["Inspect queue, worker, database, and telemetry health"]
    Compare --> Action["Create corrected version and replay safely"]
    Provider --> Action
    Tool --> Action
    Platform --> Recover["Recover dependency and resume or retry idempotently"]
```

## Flow 6: evaluation and release gate

```mermaid
sequenceDiagram
    autonumber
    actor Developer
    participant Eval as Evaluation service
    participant Baseline as Current published version
    participant Candidate as Candidate version
    participant Policy as Release policy

    Developer->>Eval: Select dataset and candidate version
    par Baseline evaluation
        Eval->>Baseline: Execute repeatable test cases
        Baseline-->>Eval: Outputs, usage, and scores
    and Candidate evaluation
        Eval->>Candidate: Execute repeatable test cases
        Candidate-->>Eval: Outputs, usage, and scores
    end
    Eval->>Eval: Compare quality, failures, latency, tokens, and cost
    Eval->>Policy: Evaluate regression thresholds
    alt Thresholds pass
        Policy-->>Developer: Candidate eligible for publication
    else Regression detected
        Policy-->>Developer: Block release with failing cases
    end
```

## Flow 7: operator deployment and recovery

```mermaid
flowchart TD
    Configure["Configure Helm values and external dependencies"] --> Validate["Validate secrets, connectivity, and migrations"]
    Validate --> Deploy["Deploy stateless services and workers"]
    Deploy --> Ready["Wait for readiness and worker registration"]
    Ready --> Smoke["Run a traced smoke workflow"]
    Smoke --> Healthy{"Health and trace complete?"}
    Healthy -- No --> Diagnose["Inspect deployment events, dependency health, and telemetry"]
    Diagnose --> Rollback{"Safe forward fix available?"}
    Rollback -- Yes --> Deploy
    Rollback -- No --> Restore["Rollback application and follow migration recovery plan"]
    Healthy -- Yes --> Operate["Monitor SLOs, queue depth, errors, cost, and capacity"]
```

## Navigation model

```mermaid
flowchart LR
    Dashboard --> Projects
    Projects --> Project["Project detail"]
    Project --> Agents
    Project --> Workflows
    Project --> Runs
    Project --> Tools
    Project --> Settings
    Agents --> Agent["Agent versions and evaluations"]
    Workflows --> Workflow["Workflow editor and versions"]
    Runs --> Run["Run summary"]
    Run --> DAG["Workflow DAG"]
    Run --> Timeline["Execution timeline"]
    Run --> Trace["Trace explorer"]
    Run --> Approval["Approval history"]
```

## Related documents

- [Detailed System Design](system-design.md)
- [Workflow Engine](workflow-engine.md)
- [Security Model](security-model.md)
- [Observability](observability.md)
