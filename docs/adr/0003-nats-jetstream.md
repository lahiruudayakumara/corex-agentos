# ADR-0003: Use NATS JetStream for Distributed Delivery

- **Status:** Accepted
- **Date:** 2026-08-09
- **Target release:** v0.6
- **Owners:** Corex AgentOS maintainers

## Context

Distributed runtime workers require durable task delivery, redelivery after
worker failure, queue groups, backpressure, delayed retries, and observable
consumer state. The platform also needs asynchronous execution events without
making a broker the canonical resource database.

v0.1 through v0.5 do not require a broker for local execution, so the choice
must not force premature distributed infrastructure into early releases.

## Decision

Use NATS JetStream as the initial durable transport for distributed execution
commands and events beginning in v0.6.

PostgreSQL remains the source of truth for platform and run state. Services use
transactional outbox/inbox patterns and idempotent consumers to bridge database
state and at-least-once message delivery.

Domain and application code depend on transport-neutral publisher and consumer
interfaces. Subject names, stream configuration, and NATS client types remain
in infrastructure packages.

## Alternatives considered

### Apache Kafka

Kafka provides mature high-throughput logs and a large ecosystem. It was not
selected initially because its operational footprint and partition model are
more complexity than the first distributed runtime requires.

### RabbitMQ

RabbitMQ offers mature work queues and routing. It was not selected because
NATS provides a compact operational model for request/reply, pub/sub, and
durable streams within the same ecosystem.

### Redis Streams

Redis is already planned for ephemeral coordination. It was not selected as
the durable execution backbone to keep caching/coordination separate from
durable task and event delivery.

### PostgreSQL-backed queue only

This minimizes infrastructure and may be sufficient before v0.6. It was not
chosen as the long-term distributed transport because worker fan-out,
backpressure, and stream operations would compete with transactional state.

## Consequences

### Positive

- Durable consumer state and redelivery support worker recovery.
- Queue groups enable horizontal worker scaling.
- A relatively small operational footprint suits self-hosting.
- Core NATS patterns can support both commands and event distribution.

### Negative

- Operators must run and monitor another stateful dependency.
- At-least-once delivery requires idempotency everywhere.
- Stream retention, subject design, and dead-letter behavior require careful
  operating policy.
- A database/broker boundary still requires outbox reconciliation.

## Guardrails

- No business invariant relies on exactly-once broker delivery.
- Messages have stable IDs, schema versions, deadlines, and correlation data.
- Consumers acknowledge only after durable effects complete.
- Poison messages have bounded delivery attempts and an inspectable terminal
  path.
- Local execution remains possible without NATS.

## Related documents

- [Event Model](../architecture/event-model.md)
- [Control Plane](../architecture/control-plane.md)
