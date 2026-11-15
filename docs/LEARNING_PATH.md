# 2026 Bug Bounty Learning Path

A curated 5-stage roadmap from fundamentals to advanced AI-assisted hunting. Synthesized from public sources including [su6osec/Bug-Bounty-Hunting-Methodology-2026](https://github.com/su6osec/Bug-Bounty-Hunting-Methodology-2026), [alham-rizvi/Bug-Bounty-Roadmap](https://github.com/alham-rizvi/Bug-Bounty-Roadmap), and community methodologies.

## Stage 1: Fundamentals
- Networking basics (TCP/IP, DNS, HTTP/HTTPS)
- Linux & terminal proficiency
- Resources: PortSwigger Web Security Academy (https://portswigger.net/web-security), alham-rizvi computernetworking.md and linuxandterminal.md
- Practice: TryHackMe or PortSwigger labs

## Stage 2: Reconnaissance
- Passive: Subfinder, Amass, cert logs, GitHub dorking, Shodan
- Active: httpx, Katana, Nuclei templates
- Ebb & Flow model: Alternate recon and testing (from R-s0n / su6osec phases)
- Tools: See TOOLING_2026.md

## Stage 3: Bug Classes
- Core: XSS, SQLi, IDOR, SSRF, SSTI, Prototype Pollution, Business Logic
- Checklists from su6osec vulnerabilities/ and master_checklist.md
- Practice on real programs with strict scope adherence

## Stage 4: Automation & AI-Assisted Workflows
- Agentic CLIs, MCP servers for tool chaining
- LLM for JS analysis, secret prioritization, report drafting
- See AI_ASSISTED_RECON.md
- Example pipeline: subfinder | httpx | katana | LLM analyzer

## Stage 5: Reporting & Career
- Structured reports with CVSS, impact, PoC
- Platforms: HackerOne, Bugcrowd
- Resources: su6osec phases/06_reporting.md, alham-rizvi h1reports.md

**Expected outcome**: After following this path with daily practice, you can systematically map attack surfaces and identify high-impact bugs using modern tooling.

Sources:
- https://raw.githubusercontent.com/su6osec/Bug-Bounty-Hunting-Methodology-2026/main/README.md
- https://raw.githubusercontent.com/alham-rizvi/Bug-Bounty-Roadmap/main/roadmap.md
