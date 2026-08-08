# Corex AgentOS

Open-source AI agent control platform for orchestrating, executing, governing,
tracing, and evaluating production AI agents.

> [!NOTE]
> The repository is in its initialization phase. The workspace and component
> boundaries are present, but most product capabilities are intentionally not
> implemented yet. See [ROADMAP.md](ROADMAP.md) for the delivery sequence.

## Repository layout

```text
apps/
  agent-runtime/   Python execution plane
  cli/             Go command-line client
  control-plane/   Go API and orchestration control layer
  portal/          React, TypeScript, and Vite developer portal
packages/
  api-client-ts/   Shared TypeScript API client
  sdk-go/          Go SDK
  sdk-python/      Python SDK
  ui/              Shared portal UI package
  workflow-spec/   Versioned workflow schemas and examples
```

The remaining top-level directories reserve boundaries for contracts,
integrations, deployment assets, infrastructure, examples, tests, and
documentation. Their contents will be added in the roadmap phase that owns
them.

## Prerequisites

- Node.js 24 or newer
- pnpm 11 or newer
- Go 1.25 or newer
- Python 3.12 or newer

## Get started

Install JavaScript dependencies and verify the initialized portal:

```shell
pnpm install
pnpm lint
pnpm build
```

Run the portal locally:

```shell
pnpm dev
```

Go and Python workspaces currently contain package metadata only. Runtime and
control-plane implementation begins with the v0.1 execution foundation.
