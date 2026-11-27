---
title: Learning Path
category: fundamentals
tags:
- learning
- roadmap
- fundamentals
- practice
order: 10
aliases:
- roadmap
- learning
---

# 2026 Bug Bounty Learning Path

A five-stage progression synthesized from public 2025–2026 sources. Each stage has a concrete goal, 2–3 resources, and a readiness gate. See also [[Recon-Methodology]] for the operational pipeline and [[Tooling-2026]] for the tools you will install.

## Stage 1 — Fundamentals (1–2 weeks)

**Goal**: Understand HTTP, DNS, the browser, and the terminal well enough to interpret tool output without guessing.

**Resources**:
- PortSwigger Web Security Academy (HTTP, authentication, and access-control labs)
- alham-rizvi/Bug-Bounty-Roadmap — networking and Linux sections (https://raw.githubusercontent.com/alham-rizvi/Bug-Bounty-Roadmap/main/README.md)
- TryHackMe Pre-Security or Introduction to Web Applications

**You’re ready when**: You can explain a request/response cycle, identify cookies vs tokens, and complete the PortSwigger HTTP and authentication labs without looking up every step.

## Stage 2 — Core Skills (2–3 weeks)

**Goal**: Perform passive subdomain enumeration, live-host probing, and basic JS analysis on a single scoped domain.

**Resources**:
- Cyber-note/Full-Bug-Bounty-Hunting-Methodology-2026 — Phases 1–3 (https://raw.githubusercontent.com/Cyber-note/Full-Bug-Bounty-Hunting-Methodology-2026/main/README.md)
- su6osec/Bug-Bounty-Hunting-Methodology-2026 — Phase 1 Passive and Phase 2 Active (https://raw.githubusercontent.com/su6osec/Bug-Bounty-Hunting-Methodology-2026/main/README.md)
- ProjectDiscovery tool docs for subfinder, httpx, and katana

**You’re ready when**: You can produce a deduplicated live-host list and a JS endpoint list for a practice target in under 30 minutes.

## Stage 3 — Practice (2–4 weeks)

**Goal**: Find and validate low-severity issues on deliberately vulnerable apps and write clear reports.

**Resources**:
- PortSwigger labs (XSS, IDOR, SSRF, business-logic)
- HackTheBox or TryHackMe web rooms focused on a single bug class
- Local intentionally-vulnerable apps (e.g., OWASP Juice Shop)

**You’re ready when**: You can reproduce a finding twice from a clean session and write a short report that another person can follow without asking questions.

## Stage 4 — Real Hunting (ongoing)

**Goal**: Operate inside program scope, prioritize by business impact, and submit triage-ready reports.

**Resources**:
- HackerOne / Bugcrowd / Intigriti program scopes and out-of-scope lists
- Community write-ups of accepted reports in the same technology stack
- [[AI-Agentic-Workflows]] for prioritization assistance (never for autonomous exploitation)

**You’re ready when**: You have submitted at least one report that was accepted or given specific, actionable feedback, and you can state the “so what” impact in one sentence.

## Stage 5 — Specialisation (ongoing)

**Goal**: Go deep on one surface (API, cloud, mobile, AI/LLM, or Web3) rather than skimming many.

**Resources**:
- Technology-specific labs and RFCs for your chosen surface
- Nuclei custom templates for that surface ([[Nuclei-Templates]])
- Recent public disclosures in the same class

**You’re ready when**: You can teach the recon and validation steps for your specialty to someone else and have a personal checklist that outperforms generic scanners.

## Daily practice checklist

- [ ] 30–45 min focused recon or lab on one target or bug class
- [ ] Note one new observation (endpoint, header, parameter, or behavior)
- [ ] Validate or discard one previous lead
- [ ] Update personal notes or this wiki with the takeaway
- [ ] Stop when diminishing returns appear; do not chase volume

Related pages: [[Recon-Methodology]], [[Tooling-2026]]

<!-- backlinks:auto-start -->

## Backlinks

- [[home\|Home]]

<!-- backlinks:auto-end -->
