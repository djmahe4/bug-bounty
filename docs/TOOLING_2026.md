# Modern Tooling 2026

Curated from public 2025-2026 methodologies (primarily su6osec/Bug-Bounty-Hunting-Methodology-2026 tools/README.md, ProjectDiscovery suite, and community toolkits like Raunaksplanet/bug-hunter-toolkit).

Prefer official install methods and @latest tags. Always verify checksums where available.

| Tool | Purpose | Install | Example Command |
|------|---------|---------|-----------------|
| subfinder | Passive subdomain enum | `go install github.com/projectdiscovery/subfinder/v2/cmd/subfinder@latest` | `subfinder -d example.com -silent -all` |
| httpx | Live host probing + tech detect | `go install github.com/projectdiscovery/httpx/cmd/httpx@latest` | `cat subs.txt \| httpx -silent -title -tech-detect -status-code` |
| katana | JS-aware crawler | `go install github.com/projectdiscovery/katana/cmd/katana@latest` | `katana -u https://example.com -jc -silent -d 2` |
| nuclei | Template-based scanning | `go install github.com/projectdiscovery/nuclei/v3/cmd/nuclei@latest` | `nuclei -u https://example.com -t cves/ -severity high,critical` |
| gitleaks | Secret scanning in git | `go install github.com/gitleaks/gitleaks/v8@latest` | `gitleaks detect --source . --report-format json` |
| trufflehog | Advanced secret detection | `pip3 install trufflehog3` or binary | `trufflehog git https://github.com/org/repo` |
| interactsh | OOB callbacks for blind vulns | `go install github.com/projectdiscovery/interactsh/cmd/interactsh-client@latest` | `interactsh-client` |
| ffuf | Fast fuzzing | `go install github.com/ffuf/ffuf/v2@latest` | `ffuf -u https://example.com/FUZZ -w wordlist.txt -mc 200,301,302` |
| waybackurls | Historical URL extraction | `go install github.com/tomnomnom/waybackurls@latest` | `echo example.com \| waybackurls` |
| gau | GetAllUrls from multiple sources | `go install github.com/lc/gau/v2/cmd/gau@latest` | `gau example.com` |

**Notes**:
- Always update tools; prefer @latest for ProjectDiscovery suite.
- For AI integration see docs/AI_ASSISTED_RECON.md.
- Full list and one-liners: https://raw.githubusercontent.com/su6osec/Bug-Bounty-Hunting-Methodology-2026/main/tools/README.md
- Additional: cariddi for endpoint/parameter extraction; AdminPBuster for admin panels.

**Expected output**: Clean, deduplicated lists of live hosts, endpoints, and potential findings ready for manual review or LLM prioritization.
