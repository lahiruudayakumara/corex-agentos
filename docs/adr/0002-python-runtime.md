# ADR-0002: Use Python for the Agent Runtime

- **Status:** Accepted
- **Date:** 2026-08-09
- **Owners:** Corex AgentOS maintainers

## Context

The agent runtime must integrate with model providers, structured output,
streaming, tools, MCP, retrieval, evaluations, and the broader AI ecosystem. It
also needs a concise public SDK for developers building agents.

The runtime is an execution plane with different dependencies and release
pressures from the Go control plane.

## Decision

Implement the agent runtime and initial public agent SDK in Python.

Define provider-independent interfaces for models, tools, events, memory, and
execution. Provider SDK objects remain inside adapters. Runtime work executes
with explicit context, deadlines, cancellation, budgets, and permissions.

The runtime can begin in-process for local v0.1 usage and later operate as a
worker behind versioned control-plane contracts.

## Alternatives considered

### Go runtime

Go would reduce production languages and provide straightforward concurrency.
It was not selected because Python has broader, faster-moving support for model
providers, evaluation libraries, data processing, and community agent tooling.

### TypeScript runtime

TypeScript offers strong model SDK support and could align with the portal. It
was not selected as the primary runtime because Python remains the most common
environment for AI and retrieval workloads targeted by the project.

### Adopt an existing agent framework as the runtime

This would speed up some early features. It was rejected as the architectural
core because it would make Corex contracts, lifecycle semantics, and provider
independence subordinate to another framework. Framework adapters may still be
added later.

## Consequences

### Positive

- Broad access to model, data, retrieval, and evaluation ecosystems.
- Familiar SDK ergonomics for AI application developers.
- Rapid adapter development for evolving providers.
- Clear failure and dependency isolation from the control plane.

### Negative

- A cross-language contract is required for distributed execution.
- Python dependency resolution and provider conflicts require discipline.
- CPU-bound or untrusted tasks may need process/container isolation.

## Guardrails

- Runtime core code depends on internal interfaces, not provider SDK types.
- Hidden global execution state is prohibited.
- Blocking provider libraries must not stall unrelated asynchronous work.
- Runtime events and errors use stable, language-neutral schemas.
- Supporting another runtime language later requires contract compatibility,
  not a rewrite of control-plane semantics.

## Related documents

- [Agent Runtime](../architecture/runtime.md)
- [ADR-0001](0001-go-control-plane.md)
