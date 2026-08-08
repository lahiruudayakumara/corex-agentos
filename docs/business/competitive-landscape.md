# Competitive Landscape

## Scope and evidence date

This comparison covers the five platforms closest to the planned Corex AgentOS
scope as of **2026-08-09**:

- Amazon Bedrock AgentCore;
- Microsoft Foundry Agent Service;
- Google Vertex AI Agent Engine;
- LangGraph with LangSmith;
- CrewAI with CrewAI AMP.

Products change quickly. Revalidate this document against official sources
before using it externally. “Corex target” means the published roadmap through
v1.0; it does not mean the capability exists today.

## Executive conclusion

Corex is entering an established category. Every comparison product is ahead
in implementation, ecosystem, production evidence, and distribution. Corex
should therefore avoid claiming that agent hosting, MCP, tracing, evaluation,
human oversight, or cloud deployment are unique.

The credible target position is:

> An Apache 2.0, fully self-hosted, provider-neutral operational control layer
> for governed agent and workflow execution, with explicit control, workflow,
> execution, data, observability, and GitOps planes.

LangGraph/LangSmith is the closest architectural competitor. AWS AgentCore is
the strongest managed-cloud feature competitor. Microsoft and Google are the
strongest ecosystem choices for customers already standardized on their clouds.
CrewAI is the closest high-level multi-agent developer experience competitor.

## Product model comparison

| Platform | Current status | Primary model | Hosting documented by vendor | Main ecosystem gravity |
| --- | --- | --- | --- | --- |
| Corex today | Initialization and v0.1 foundation work | Open-source project | Local scaffolding only; production hosting not delivered | Intended to be neutral |
| Corex target | Roadmap through v1.0 | Apache 2.0 self-hosted platform plus possible commercial services | Local, containers, and self-hosted Kubernetes | Models, MCP, OpenTelemetry, and portable infrastructure |
| AWS AgentCore | Production managed services with continuing feature releases | Modular managed agent platform | AWS-managed runtime and services | AWS IAM, CloudWatch, Bedrock, and AWS infrastructure |
| Microsoft Foundry Agent Service | Managed platform; some capabilities documented as preview | Managed agent hosting and lifecycle | Microsoft-managed hosting; external agents can be registered for observability | Azure, Entra, Foundry models/tools, Application Insights |
| Google Vertex AI Agent Engine | Managed runtime with GA and preview subservices | Managed production agent runtime | Google Cloud-managed runtime | Vertex AI, IAM, VPC-SC, Cloud Trace/Monitoring/Logging |
| LangGraph and LangSmith | Mature orchestration framework and commercial platform | Low-level graph runtime plus observability/evaluation/deployment | Cloud, hybrid, enterprise self-hosted, or standalone server | LangGraph and LangChain ecosystem |
| CrewAI and AMP | Open agent framework plus managed production platform | Crews and event-driven flows | AMP managed deployment documented; GitHub, Studio, and CLI deployment | CrewAI agents, crews, flows, tools, and automations |

Official references: [AWS AgentCore overview](https://docs.aws.amazon.com/bedrock-agentcore/latest/devguide/what-is-bedrock-agentcore.html),
[Microsoft hosted agents](https://learn.microsoft.com/en-us/azure/foundry/agents/concepts/hosted-agents),
[Google Agent Engine](https://cloud.google.com/vertex-ai/generative-ai/docs/reasoning-engine/overview),
[LangGraph overview](https://docs.langchain.com/oss/python/langgraph/overview),
[LangSmith deployment modes](https://docs.langchain.com/langsmith/platform-setup),
and [CrewAI AMP](https://docs.crewai.com/enterprise/introduction).

## Capability matrix

Legend:

- **Current:** documented as available by the vendor.
- **Partial:** available through selected services, integrations, framework code,
  or with narrower scope.
- **Enterprise:** documented behind an enterprise/self-hosted commercial plan.
- **Planned:** present in the Corex roadmap but not delivered.
- **Not central:** not presented as a primary capability in the reviewed source.

| Capability | Corex today | Corex target | AWS AgentCore | Microsoft Foundry | Google Agent Engine | LangGraph/LangSmith | CrewAI/AMP |
| --- | --- | --- | --- | --- | --- | --- | --- |
| Local agent SDK/runtime | Not functional | Planned v0.1 | Partial through SDK/framework choice | Current for local framework development | Current through supported Python frameworks | Current | Current |
| Managed hosting | No | Possible after v1, not committed | Current | Current | Current | Current cloud | Current AMP |
| Full self-hosting | No | Planned v1.0 | Not central | Not central for Foundry service | Not central | Enterprise | Not established by reviewed AMP source |
| Multi-cloud portability | Architectural target | Planned | Framework/model flexible but AWS-operated | External/custom agents supported; Azure control services | Multiple frameworks/models within Google Cloud service | Cloud, hybrid, and self-hosted modes | Framework portable; AMP is managed |
| Framework independence | Not implemented | Target through stable contracts | Current: works with multiple frameworks | Current: bring custom code or supported frameworks | Partial: several supported Python frameworks | Partial: observability broad, deployment centered on LangGraph | No: centered on CrewAI abstractions |
| Model-provider independence | Not implemented | Planned v0.1 | Current: supports Bedrock and external models | Partial through Foundry catalog and custom code | Partial through Vertex model ecosystem | Current through model integrations | Current through model integrations |
| Durable workflows | Not implemented | Planned v0.3 | Framework-dependent | Framework/custom-code dependent | Framework-dependent | Current core strength | Current flows and persisted state |
| Multi-agent orchestration | Not implemented | Planned v0.3 | Framework-dependent | Supported through chosen agent framework | Supported through ADK and other frameworks | Current through graphs | Current core strength |
| Human-in-the-loop | Not implemented | Planned v0.3-v0.5 | Not central in reviewed platform overview | Partial through custom workflow/application logic | Framework-dependent | Current core strength | Current triggers and workflow patterns |
| Deterministic tool policy | Not implemented | Planned v0.5 | Current through Policy in AgentCore and Cedar | Partial through identity, toolbox authorization, and Azure controls | Partial through IAM and cloud controls | Application/framework responsibility | Guardrails and RBAC; policy depth differs |
| Human approval records | Not implemented | Planned v0.5 | Not central in reviewed policy docs | Not central in reviewed hosted-agent docs | Not central in reviewed overview | Can implement interrupts; platform record depends on design | Human-in-loop supported; record model depends on flow |
| MCP/tool gateway | Not implemented | Planned v0.4 | Current gateway, registry, policy, and MCP support | Current Toolbox with custom MCP connections | Partial through tools and MCP integrations | Available through integrations | Tool ecosystem; MCP scope should be revalidated |
| Agent identity | Not implemented | Planned v0.2-v1.0 | Current through AgentCore Identity and IAM | Current dedicated Entra identity for hosted agents | Identity/IAM capabilities documented | Deployment authentication varies by mode | Team/RBAC documented; runtime identity differs |
| Memory and sessions | Not implemented | Planned v0.4 | Current AgentCore services | Current hosted session persistence | Sessions and Memory Bank include preview capabilities | Current short- and long-term memory patterns | Current memory and knowledge patterns |
| RAG and knowledge | Not implemented | Planned v0.4 | Current through tools, memory, and integrations | Current through Azure AI Search/tools/MCP | Current through Vertex services and integrations | Integration ecosystem | Current knowledge features |
| Tracing and observability | Not implemented | v0.1 foundation; full v0.7 | Current through AgentCore observability and CloudWatch | Current through OpenTelemetry/Application Insights | Current through Cloud Trace, Monitoring, and Logging | Current core LangSmith strength | Current AMP traces and logs |
| Evaluation | Not implemented | Planned v0.5 | Current AgentCore Evaluations | Current, including trace-based evaluation capabilities | Current/preview mix through Gen AI Evaluation | Current core LangSmith strength | Partial; revalidate formal evaluation depth |
| Cost and token analytics | Not implemented | Planned v0.1 and v0.7 | AWS usage/cost tooling and guidance | Azure usage/billing ecosystem; agent-specific views vary | Google Cloud usage/billing ecosystem; agent-specific views vary | Usage and tracing features; packaging varies | Observability available; cost depth should be validated |
| Distributed worker pools | Not implemented | Planned v0.6 | Managed scaling and isolation | Managed scaling and sandbox lifecycle | Managed scaling | Deployment/control and data planes | Managed scaling through AMP |
| Runtime isolation | Not implemented | Investigated v0.6, hardened later | Current isolated runtime options | Current per-session VM-isolated hosted sandboxes | Managed runtime and sandbox capabilities | Depends on deployment configuration | Depends on deployment configuration |
| Git-based deployment | Portal repository only | Planned GitOps plane | Cloud/IaC ecosystem, not central in reviewed overview | Container and `azd` definitions | Starter Pack includes Terraform and Cloud Build | GitHub deployment and CI/CD documented | GitHub integration documented |
| First-class GitOps reconciliation | No | Planned architecture; implementation release TBD | Not central | Not central | Not central | CI/CD available; reconciler is customer concern | Not central |
| OpenTelemetry portability | Not implemented | Planned | Observability integrates primarily with AWS services | Current OpenTelemetry support | Current OpenTelemetry/Cloud Trace support | Current tracing ecosystem | Observability available; exporter depth varies |
| Open-source core platform | Repository is Apache 2.0 | Yes | No | No | No | LangGraph is open source; LangSmith is commercial | CrewAI framework is open; AMP is commercial |

## Direct comparison: Corex versus AWS AgentCore

### AWS advantages

- Production-managed runtime, identity, gateway, memory, observability, policy,
  registry, and evaluation services already exist.
- AgentCore documents compatibility with multiple frameworks and foundation
  models.
- Fine-grained tool authorization is implemented through Cedar-based Policy in
  AgentCore, evaluated outside agent code.
- AWS distribution, IAM, CloudWatch, and infrastructure integration reduce
  adoption friction for AWS customers.

See the [AgentCore overview](https://docs.aws.amazon.com/bedrock-agentcore/latest/devguide/what-is-bedrock-agentcore.html)
and [Policy in AgentCore](https://docs.aws.amazon.com/bedrock-agentcore/latest/devguide/policy.html).

### Corex target advantages

- Full Apache 2.0 foundation and self-hosting without requiring AWS services.
- Explicit replacement of PostgreSQL, NATS, Redis, telemetry, model, and tool
  infrastructure through portable contracts.
- A cohesive workflow and GitOps architecture rather than only managed agent
  services.
- Potential appeal to organizations that need infrastructure ownership or
  cloud-vendor neutrality.

### Corex gap

AWS is far ahead in implementation, security integration, isolation, operating
evidence, and distribution. “MCP-first” or “provider-flexible” alone is not a
defensible distinction from AgentCore.

## Direct comparison: Corex versus Microsoft Foundry Agent Service

### Microsoft advantages

- Managed container lifecycle, scaling, session persistence, security, and
  dedicated Entra identity.
- Supports custom agent code and multiple frameworks.
- Toolbox exposes managed tools and custom MCP connections with consolidated
  authentication.
- Strong integration with Azure identity, networking, models, monitoring, and
  enterprise procurement.
- Can register externally hosted agents for Foundry trace and evaluation views.

See [hosted agents](https://learn.microsoft.com/en-us/azure/foundry/agents/concepts/hosted-agents)
and [external agent observability](https://learn.microsoft.com/en-us/azure/foundry/agents/how-to/register-external-agent).

### Corex target advantages

- Fully self-hosted control and data planes rather than an Azure-managed agent
  service.
- Identity-provider and cloud neutrality.
- Explicit durable workflow, policy, event, and GitOps contracts intended to be
  portable across environments.

### Corex gap

Microsoft already combines identity, hosting, toolbox/MCP, tracing, evaluation,
and enterprise distribution. Corex must prove that infrastructure ownership and
neutrality justify the operational burden of self-hosting.

## Direct comparison: Corex versus Google Vertex AI Agent Engine

### Google advantages

- Managed runtime, scaling, IAM, sessions, memory, evaluation, and observability.
- Supports several Python frameworks, with deeper integration for ADK,
  LangChain, and LangGraph.
- Strong integration with Google data, model, security, and operations systems.
- Agent Starter Pack provides templates, Terraform, Cloud Build pipelines, and
  observability.

See the [Vertex AI Agent Engine overview](https://cloud.google.com/vertex-ai/generative-ai/docs/reasoning-engine/overview).

### Corex target advantages

- Self-hosted Kubernetes operation across clouds and on-premises.
- No required dependency on Vertex AI, Google IAM, or Google observability.
- A platform-controlled MCP, policy, workflow, and event model.

### Corex gap

Google has a production cloud, data ecosystem, managed runtime, and deployment
tooling. Corex must make cross-cloud portability real through tested adapters
and repeatable deployments rather than architectural diagrams alone.

## Direct comparison: Corex versus LangGraph and LangSmith

### LangGraph/LangSmith advantages

- Durable execution, human-in-the-loop, state, memory, and long-running graphs
  are available now.
- LangSmith provides strong tracing, evaluation, prompt tooling, deployment,
  and Studio experiences.
- Cloud, hybrid, enterprise self-hosted, and standalone deployment modes are
  documented.
- A large existing LangChain/LangGraph ecosystem and developer mindshare.

See the [LangGraph overview](https://docs.langchain.com/oss/python/langgraph/overview)
and [LangSmith platform setup](https://docs.langchain.com/langsmith/platform-setup).

### Corex target advantages

- Framework-independent operational contracts rather than requiring the
  LangGraph programming model for the workflow/runtime core.
- Apache-licensed target control plane rather than self-hosted platform access
  limited to an enterprise commercial plan.
- First-class project governance, MCP registry, distributed worker, policy,
  credential, audit, and GitOps planes in the target architecture.
- Separate Go management plane and Python execution plane.

### Corex gap

This is Corex’s hardest open-platform comparison. LangGraph already delivers
the durable workflow and developer-runtime value that Corex plans for v0.3,
while LangSmith covers much of the planned AgentOps experience. Corex needs a
clear interoperability story—potentially running LangGraph workloads—rather
than treating LangGraph only as a product to replace.

## Direct comparison: Corex versus CrewAI and AMP

### CrewAI advantages

- High-level agents, crews, tasks, event-driven flows, guardrails, memory, and
  knowledge are available now.
- AMP provides managed deployment, REST APIs, tracing, logs, tool repository,
  webhook streaming, and a no-code/low-code Studio.
- The role-based “crew” model is easy to explain and adopt for multi-agent
  automation.

See the [CrewAI documentation](https://docs.crewai.com/index) and
[CrewAI AMP introduction](https://docs.crewai.com/enterprise/introduction).

### Corex target advantages

- Does not require customers to model agents and workflows as CrewAI crews and
  flows.
- Explicit self-hosted infrastructure, event, policy, data, and GitOps design.
- Lower-level operational layer that could host or integrate several agent
  frameworks.

### Corex gap

CrewAI offers a faster path to building understandable multi-agent automations
today. Corex’s lower-level neutrality could feel complex unless its SDK,
examples, portal, and flagship workflow provide equally fast first value.

## Strategic scorecard

This scorecard is directional, not a benchmark. It compares documented product
position, not audited customer outcomes.

| Dimension | Corex target position | Strongest current competitor | Required proof from Corex |
| --- | --- | --- | --- |
| Open, fully self-hosted foundation | Potential strength | LangGraph is open; LangSmith self-hosting is enterprise | Working Apache-licensed end-to-end deployment |
| Managed convenience | Weak by design initially | AWS, Microsoft, and Google | Supported deployment and low operating burden |
| Durable orchestration | Planned | LangGraph; CrewAI for higher-level flows | Failure recovery and idempotency tests |
| Tool policy and identity | Planned | AWS AgentCore; Microsoft cloud identity | External enforcement, least privilege, and audit evidence |
| MCP ecosystem | Planned, no longer unique | AWS and Microsoft | Portable integrations plus governance quality |
| Observability and evaluation | Planned | LangSmith; cloud platforms | Complete trace, reproducible evaluation, and useful diagnosis |
| Cloud neutrality | Architectural strength | LangGraph/LangSmith deployment modes | Real deployments on multiple infrastructures |
| GitOps-first operations | Potential strength | Cloud CI/CD ecosystems | Tested reconciliation, migrations, provenance, and rollback |
| Developer speed | Major risk | CrewAI and LangGraph | Fast install-to-first-traced-run and excellent examples |
| Enterprise distribution | Major weakness | AWS, Microsoft, and Google | Design partners, references, support, and channel partners |

## Recommended positioning

### Say

- “Self-hosted operational infrastructure for governed AI agents and
  workflows.”
- “Bring your models, tools, MCP servers, frameworks, identity, data, and
  observability backends.”
- “One explicit operational contract across control, workflow, execution,
  governance, data, observability, and GitOps planes.”
- “Designed for organizations that need infrastructure ownership and portable
  governance.”

### Do not say without evidence

- “The first complete agent platform.”
- “The only MCP-first or provider-independent platform.”
- “More secure, scalable, or reliable than AWS, Microsoft, Google, LangSmith,
  or CrewAI.”
- “Production-ready” before the roadmap’s production criteria are met.
- “Enterprise-grade” without security, support, deployment, and reference
  evidence.

## Product strategy implications

1. **Finish the narrow v0.1 proof.** Competing on roadmap breadth before a
   reliable local execution trace exists will not be credible.
2. **Interoperate with frameworks.** Treat LangGraph and CrewAI workloads as
   integration opportunities where possible.
3. **Make governance external to agent code.** AWS demonstrates why deterministic
   tool-boundary policy is a strong enterprise requirement.
4. **Make self-hosting genuinely easy.** Portability without tested upgrades,
   telemetry, backup, and recovery is only theoretical.
5. **Measure developer first value.** The portal, SDK, and flagship workflow
   must offset the complexity of a broader operational architecture.
6. **Prove GitOps as a real distinction.** Deliver schema checks, signed
   artifacts, migrations, reconciliation, and rollback—not only a diagram.
7. **Use design partners to select scope.** Do not attempt immediate feature
   parity with five mature ecosystems.

## Revalidation checklist

Review quarterly or before external investor/partner use:

- product availability and preview/GA status;
- hosting and self-hosting options;
- open-source and commercial licensing;
- model and framework compatibility;
- MCP, policy, identity, approval, and audit capabilities;
- workflow durability and recovery semantics;
- observability and evaluation packaging;
- pricing and enterprise-plan restrictions;
- Git-based deployment and infrastructure requirements;
- Corex implementation evidence versus roadmap claims.
