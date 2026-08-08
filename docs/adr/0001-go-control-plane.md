# ADR-0001: Use Go for the Control Plane

- **Status:** Accepted
- **Date:** 2026-08-09
- **Owners:** Corex AgentOS maintainers

## Context

The control plane must expose versioned APIs, coordinate durable resources and
background work, integrate with PostgreSQL and messaging infrastructure, and
operate as a long-running service. It should remain straightforward to deploy,
observe, and scale without requiring the agent execution environment.

The agent runtime benefits from Python's AI ecosystem, but using the same
language for every component would couple management services to rapidly
changing model/runtime dependencies.

## Decision

Implement the Corex AgentOS control plane and first-party CLI in Go.

Keep the control plane as a modular service initially. Domain packages expose
narrow interfaces, and network services are extracted only when scaling,
reliability, ownership, or deployment constraints justify the split.

Communication with the Python runtime uses versioned language-neutral
contracts. Go-specific types are not public wire formats.

## Alternatives considered

### Python control plane

Python would reduce the initial number of languages and allow code sharing with
the runtime. It was not selected because management-plane concerns need little
of the Python AI ecosystem, and sharing a process would weaken dependency and
failure isolation.

### TypeScript control plane

TypeScript would align with the portal and provide a productive API ecosystem.
It was not selected because Go offers a smaller operational runtime, strong
concurrency primitives, and a natural fit for infrastructure-oriented services.

### Separate microservices from the start

This could create independent scaling boundaries immediately. It was rejected
as premature complexity before workload and ownership data exists.

## Consequences

### Positive

- The control plane can ship as a statically compiled service with predictable
  resource usage.
- Strong typing and concurrency support fit API, scheduler, and worker-control
  workloads.
- Runtime provider dependencies remain isolated from management services.
- Module boundaries can later become service boundaries without starting as a
  distributed system.

### Negative

- Contributors may need both Go and Python expertise.
- Contracts and generated clients must bridge the Go/Python boundary.
- Similar concepts cannot be shared through in-process language types.

## Guardrails

- Domain packages do not depend on transport or database frameworks.
- The control plane does not execute model/tool loops.
- Cross-language contracts are versioned and compatibility-tested.
- Service extraction requires a separate ADR.

## Related documents

- [Control Plane](../architecture/control-plane.md)
- [Architecture Overview](../architecture/overview.md)
