# Master Bug Bounty Checklist (2026 Synthesis)

Synthesized and paraphrased from public sources including su6osec/Bug-Bounty-Hunting-Methodology-2026 checklists/master_checklist.md and recon_checklist.md. Use as a high-level guide; always adapt to program scope.

## Phase 0: Scope & Analysis
- [ ] Read full program scope, rules, and out-of-scope
- [ ] Classify target: wide (many assets), medium, or narrow (single app)
- [ ] Identify high-value assets (auth, payment, admin, APIs)
- [ ] Note tech stack hints from public sources

## Phase 1: Passive Recon
- [ ] Subdomain enum: subfinder, amass, crt.sh, GitHub search
- [ ] ASN / CIDR expansion if applicable
- [ ] Historical: waybackurls, gau, archive.org
- [ ] OSINT: Shodan, GitHub dorks for secrets/endpoints
- [ ] Output: all_subs.txt, historical_urls.txt

## Phase 2: Active Enumeration
- [ ] Resolve and probe: httpx -title -tech-detect -status-code
- [ ] Port scan high-value hosts (nmap or masscan, carefully)
- [ ] Crawl: katana -jc, gospider
- [ ] Parameter discovery: arjun, paramspider, Burp Param Miner
- [ ] JS analysis: download, beautify, extract endpoints/secrets
- [ ] Output: live.txt, urls.txt, params.txt, js_endpoints.txt

## Phase 3: Vulnerability Discovery (Ebb & Flow)
- [ ] Pick 3-5 promising vectors (injection or logic)
- [ ] Test briefly; document any findings
- [ ] If stuck, expand recon and repeat
- [ ] Core checks:
  - [ ] Access control / IDOR (horizontal + vertical)
  - [ ] XSS (reflected, stored, DOM)
  - [ ] SQLi / NoSQLi
  - [ ] SSRF (with OOB interactsh)
  - [ ] Business logic (race, price, workflow bypass)
  - [ ] Auth flaws (reset, 2FA, session)
  - [ ] API / GraphQL issues
- [ ] Use nuclei for quick templates; manual for logic

## Phase 4: Exploitation & PoC
- [ ] Reproduce reliably with minimal steps
- [ ] Escalate impact (chain bugs if possible)
- [ ] Capture evidence (screenshots, requests)

## Phase 5: Reporting
- [ ] Clear title with impact
- [ ] Steps to reproduce + PoC
- [ ] Business impact + CVSS
- [ ] Remediation suggestions
- [ ] Follow program template

**Expected outcome**: Systematic coverage that prioritizes high-impact issues while maintaining thorough recon.

Sources:
- https://raw.githubusercontent.com/su6osec/Bug-Bounty-Hunting-Methodology-2026/main/checklists/master_checklist.md
- https://github.com/su6osec/Bug-Bounty-Hunting-Methodology-2026
