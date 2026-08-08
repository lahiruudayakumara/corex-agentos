# Documentation

Corex AgentOS documentation distinguishes the intended architecture from the
capabilities available in the current release. Unless a document explicitly
says otherwise, architecture pages describe the target design from the
[roadmap](../ROADMAP.md), not a completed implementation.

## Architecture

- [System overview](architecture/overview.md)
- [Architecture delivery path](architecture/implementation-path.md)
- [Platform planes and modules](architecture/platform-planes.md)
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

## Commercialization, investment, and partnerships

- [Business documentation index](business/README.md)
- [Commercialization strategy](business/commercialization-strategy.md)
- [Competitive landscape](business/competitive-landscape.md)
- [Investor brief](business/investor-brief.md)
- [Metrics and financial model](business/metrics-and-financial-model.md)
- [Partner program](business/partner-program.md)

Business documents are planning materials rather than an investment offer,
financial forecast, legal commitment, or announced product packaging.

## Users, capabilities, and access

- [Product documentation index](product/README.md)
- [Personas and use cases](product/personas-and-use-cases.md)
- [Complete capability catalog](product/capability-catalog.md)
- [Roles and permissions](product/roles-and-permissions.md)
