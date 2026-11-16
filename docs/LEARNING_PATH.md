# 2026 Bug Bounty Learning Path

A curated 5-stage roadmap from fundamentals to advanced AI-assisted hunting. Synthesized from public sources including [su6osec/Bug-Bounty-Hunting-Methodology-2026](https://github.com/su6osec/Bug-Bounty-Hunting-Methodology-2026) (HuntBook phases), [alham-rizvi/Bug-Bounty-Roadmap](https://github.com/alham-rizvi/Bug-Bounty-Roadmap), and community methodologies like hexsecteam/Bug-Bounty-Hunting-Methodology-2026.

This path emphasizes structured progression, manual validation over pure automation, and integration of AI for prioritization (not replacement of human judgment).

## Stage 1: Fundamentals (1-2 weeks)
- Networking basics: TCP/IP, DNS, HTTP/HTTPS request/response cycles, status codes, headers.
- Linux & terminal: Navigation, pipes, grep, jq, process management.
- Web app basics: Client-server model, cookies, sessions, authentication flows.
- Resources:
  - PortSwigger Web Security Academy (https://portswigger.net/web-security)
  - alham-rizvi computernetworking.md and linuxandterminal.md
  - TryHackMe Pre-Security or Introduction to Web Applications paths
- Practice: Complete PortSwigger labs on HTTP, authentication.

## Stage 2: Reconnaissance (2-3 weeks)
- Passive: Subfinder, Amass, cert logs (crt.sh), GitHub dorking, Shodan, ASN enumeration, Wayback Machine.
- Active: httpx for live hosts + tech detect, Katana for JS-aware crawling, parameter discovery.
- Ebb & Flow model: Alternate recon and testing (from R-s0n / su6osec Phase 3) — find 3-5 vectors, test briefly, expand surface, repeat.
- Scope analysis first (su6osec Phase 0): Classify wide/medium/narrow targets.
- Tools: See docs/TOOLING_2026.md
- Outcome: Clean lists of live hosts, endpoints, JS files for manual review.

## Stage 3: Bug Classes (3-4 weeks)
- Core high-payout: Broken Access Control (IDOR, privilege escalation), XSS (reflected/stored/DOM), SQLi, SSRF, business logic flaws.
- Emerging 2026: AI/LLM injection, prototype pollution, GraphQL/API abuse.
- Checklists from su6osec vulnerabilities/ and master_checklist.md; hexsecteam two-eye approach.
- Practice: PortSwigger labs + authorized programs (start with VDPs).
- Focus on depth over volume; prove impact (ATO, data exposure).

## Stage 4: Automation & AI-Assisted Workflows (ongoing)
- Agentic CLIs and MCP servers for safe tool chaining (e.g., HexStrike AI patterns).
- LLM for JS analysis (extract endpoints/secrets), secret prioritization from GitHub, report drafting.
- Semi-automated pipelines: subfinder | httpx | katana | LLM prioritizer.
- See docs/AI_ASSISTED_RECON.md and scripts/.
- Guardrails: Always verify manually; rate-limit; dry-run on example.com.

## Stage 5: Reporting & Career (continuous)
- Structured reports: Title with impact, minimal PoC, business risk quantification, CVSS.
- Platforms: HackerOne, Bugcrowd, Intigriti; also independent VDPs.
- Resources: su6osec phases/06_reporting.md, alham-rizvi h1reports.md, abhihackz.com 2026 playbook.
- Tips: One high-quality report > many noisy ones; focus on triage-ready submissions.

**Expected outcome**: After following this path with daily deliberate practice (90-day framework style), you can systematically map attack surfaces, identify high-impact bugs using modern tooling, and produce professional reports.

### Sources
- https://raw.githubusercontent.com/su6osec/Bug-Bounty-Hunting-Methodology-2026/main/README.md
- https://github.com/alham-rizvi/Bug-Bounty-Roadmap
- https://github.com/hexsecteam/Bug-Bounty-Hunting-Methodology-2026
- Community 2026 roadmaps (Undercode Testing, chs.us guides)
