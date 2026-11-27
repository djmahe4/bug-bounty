---
title: AI Agentic Workflows
category: methodology
tags:
- ai
- agentic
- mcp
- triage
- workflow
order: 50
aliases:
- agentic
- ai-workflows
---

# AI Agentic Workflows

How agentic CLIs and MCP servers fit a bug-bounty pipeline without replacing human judgment. See [[Tooling-2026]] for concrete tools and the validation skill for the triage gate.

## Where agents help

- Summarizing large `httpx` or `katana` output into prioritized lists
- Drafting initial notes from public recon data
- Suggesting next manual checks based on tech fingerprints
- Formatting report skeletons after you have confirmed a finding

## Where agents must not act alone

- Deciding scope
- Sending exploit payloads
- Accessing data beyond a minimal proof-of-concept
- Submitting reports

## Safe prompt template (httpx triage)

```
You are assisting with authorized bug-bounty reconnaissance.

Scope (do not expand): [paste program scope]
Out of scope: [paste exclusions]

Input: httpx output below (titles, tech, status).
Task:
1. Group hosts by technology.
2. Flag hosts that look like admin, staging, API, or debug.
3. Suggest 3 manual checks per group (no payloads).
4. List anything that appears out of scope.

Do not generate exploit code. Do not recommend actions outside the listed scope.
If a host is ambiguous, mark it for human review.

httpx output:
[paste]
```

## Guardrails

1. **Scope check first** — paste the current program scope into every session; reject suggestions that leave it.
2. **Human-in-the-loop** — every agent recommendation is a hypothesis until you reproduce it.
3. **Least privilege MCP** — grant only the tools required (e.g., read-only file access); never unrestricted shell or credentialed API access by default.
4. **No autonomous exploitation** — agents may summarize or suggest; humans send requests and confirm impact.
5. **Audit trail** — keep the prompt, the output, and your decision (accept/reject/modify).

## MCP server notes

An MCP server exposes tools to an agent. Common risks observed in 2025–2026 include tool-description poisoning (hidden instructions in tool metadata), token passthrough to downstream APIs, and missing object-level authorization. Prefer well-reviewed servers (e.g., scoped Nuclei or program-aware MCP), pin versions, review tool descriptions before connecting, and apply least-privilege. See public MCP security discussions (tool poisoning, DNS rebinding on local servers) for current failure modes. Always keep a human approval gate for any tool that sends traffic or modifies state.

Related pages: [[Tooling-2026]], [[validation-skill]]

<!-- backlinks:auto-start -->

## Backlinks

- [[home\|Home]]
- [[learning-path\|Learning Path]]
- [[tooling-2026\|Tooling 2026]]
- [[validation-skill\|Validation Skill]]

<!-- backlinks:auto-end -->
