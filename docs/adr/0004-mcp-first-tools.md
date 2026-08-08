# ADR-0004: Prefer MCP for External Tool Integrations

- **Status:** Accepted
- **Date:** 2026-08-09
- **Target release:** v0.4
- **Owners:** Corex AgentOS maintainers

## Context

Agents need access to repositories, filesystems, databases, APIs, and business
systems. Building a proprietary adapter contract for every integration would
increase maintenance, encourage vendor lock-in, and make tools difficult to use
outside Corex AgentOS.

The Model Context Protocol (MCP) provides a portable mechanism for tool
discovery, schemas, invocation, and server lifecycle while allowing tools to
run outside the agent process.

## Decision

Use MCP as the preferred protocol for external tool integrations.

Corex registers MCP servers, discovers their tools, maps tool schemas into the
runtime abstraction, applies Corex permission and policy checks, and traces
invocations. The runtime-facing tool interface remains protocol-neutral so
small trusted in-process tools and future protocols are still possible.

Supported transports follow explicitly selected MCP specification versions.
Connections and discovered capabilities are versioned or snapshotted enough to
make a run diagnosable.

## Alternatives considered

### Proprietary Corex plugin RPC

A custom RPC could be tailored precisely to Corex. It was rejected as the
default because it would create a closed integration ecosystem and duplicate
protocol lifecycle and schema work.

### In-process Python functions only

This is simple for local prototypes but couples tools to the Python runtime,
weakens isolation, and excludes tools written in other languages.

### Direct REST adapters

REST remains useful behind an MCP server or for narrow internal adapters. As a
platform-wide tool contract it lacks a consistent discovery, metadata, and
invocation model.

## Consequences

### Positive

- Integrations are portable across MCP-compatible clients and servers.
- Tools can be implemented in any language and deployed independently.
- Discovery and JSON-compatible schemas reduce bespoke adapter code.
- Process/network boundaries support stronger isolation than in-process tools.

### Negative

- MCP specification and SDK evolution must be managed explicitly.
- Server trust, health, transport security, and lifecycle add operational work.
- MCP tool metadata alone is insufficient for Corex risk and approval policy.
- Remote invocation adds latency and new failure modes.

## Guardrails

- Discovery never grants permission automatically.
- Every tool is assigned Corex-side identity, risk, side-effect, timeout, and
  permission metadata.
- Arguments are schema-validated before dispatch and results are treated as
  untrusted content.
- Credentials are scoped per server/tool and never exposed to the model.
- Tool calls emit events and spans with content redaction controls.
- Side-effecting calls are not blindly retried or replayed.

## Related documents

- [Agent Runtime](../architecture/runtime.md)
- [Security Model](../architecture/security-model.md)
- [Observability](../architecture/observability.md)
