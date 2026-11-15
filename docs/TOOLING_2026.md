# Modern Tooling 2026

Curated from public 2025-2026 methodologies (primarily su6osec/Bug-Bounty-Hunting-Methodology-2026 tools/README.md).

| Tool | Purpose | Install | Example Command |
|------|---------|---------|-----------------|
| subfinder | Passive subdomain enum | `go install github.com/projectdiscovery/subfinder/v2/cmd/subfinder@latest` | `subfinder -d example.com -silent` |
| httpx | Live host probing + tech detect | `go install github.com/projectdiscovery/httpx/cmd/httpx@latest` | `cat subs.txt \| httpx -silent -title -tech-detect` |
| katana | JS-aware crawler | `go install github.com/projectdiscovery/katana/cmd/katana@latest` | `katana -u https://example.com -jc -silent` |
| nuclei | Template-based scanning | `go install github.com/projectdiscovery/nuclei/v3/cmd/nuclei@latest` | `nuclei -u https://example.com -t cves/` |
| gitleaks | Secret scanning in git | `go install github.com/gitleaks/gitleaks/v8@latest` | `gitleaks detect --source .` |
| trufflehog | Advanced secret detection | `pip3 install trufflehog3` | `trufflehog git https://github.com/org/repo` |
| interactsh | OOB callbacks for blind vulns | `go install github.com/projectdiscovery/interactsh/cmd/interactsh-client@latest` | `interactsh-client` |
| ffuf | Fast fuzzing | `go install github.com/ffuf/ffuf/v2@latest` | `ffuf -u https://example.com/FUZZ -w wordlist.txt` |

**Notes**:
- Always update tools; prefer @latest for ProjectDiscovery suite
- For AI integration see AI_ASSISTED_RECON.md
- Full list and one-liners: https://raw.githubusercontent.com/su6osec/Bug-Bounty-Hunting-Methodology-2026/main/tools/README.md

Expected output: Clean lists of live hosts, endpoints, and potential findings ready for manual review.
