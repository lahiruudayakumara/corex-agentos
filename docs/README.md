# Documentation

Corex AgentOS documentation distinguishes the intended architecture from the
capabilities available in the current release. Unless a document explicitly
says otherwise, architecture pages describe the target design from the
[roadmap](../ROADMAP.md), not a completed implementation.

## Architecture

- [System overview](architecture/overview.md)
- [Detailed system design](architecture/system-design.md)
- [User and operator flows](architecture/user-flows.md)
- [Control plane](architecture/control-plane.md)
- [Agent runtime](architecture/runtime.md)
- [Workflow engine](architecture/workflow-engine.md)
- [Event model](architecture/event-model.md)
- [Security model](architecture/security-model.md)
- [Observability](architecture/observability.md)

## Architecture decision records

- [ADR-0001: Go control plane](adr/0001-go-control-plane.md)
- [ADR-0002: Python agent runtime](adr/0002-python-runtime.md)
- [ADR-0003: NATS JetStream for distributed delivery](adr/0003-nats-jetstream.md)
- [ADR-0004: MCP-first tool integrations](adr/0004-mcp-first-tools.md)

ADRs record consequential decisions and their tradeoffs. Accepted ADRs are not
silently rewritten when a decision changes; a new ADR supersedes the old one.
