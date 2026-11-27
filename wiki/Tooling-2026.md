---
title: Tooling 2026
category: tooling
tags:
- tools
- nuclei
- subfinder
- mcp
- agentic
order: 40
aliases:
- tooling
- tools
---

# Tooling 2026

Current practical tooling for bug-bounty work. Prefer official install methods and pin versions in production pipelines. See [[AI-Agentic-Workflows]] for how agentic CLIs and MCP servers fit the pipeline.

| name | purpose | install | example | level | source |
|------|---------|---------|---------|-------|--------|
| subfinder | Passive subdomain enumeration | `go install github.com/projectdiscovery/subfinder/v2/cmd/subfinder@latest` | `subfinder -d example.com -all -silent` | beginner | https://github.com/projectdiscovery/subfinder |
| httpx | Live host probing and tech detect | `go install github.com/projectdiscovery/httpx/cmd/httpx@latest` | `cat subs.txt \| httpx -silent -title -tech-detect` | beginner | https://github.com/projectdiscovery/httpx |
| katana | JS-aware crawler | `go install github.com/projectdiscovery/katana/cmd/katana@latest` | `katana -u https://example.com -jc -d 2 -silent` | intermediate | https://github.com/projectdiscovery/katana |
| dnsx | DNS resolution and wildcard filter | `go install github.com/projectdiscovery/dnsx/cmd/dnsx@latest` | `dnsx -l subs.txt -silent -resp` | beginner | https://github.com/projectdiscovery/dnsx |
| nuclei | Template-based scanning | `go install github.com/projectdiscovery/nuclei/v3/cmd/nuclei@latest` | `nuclei -l httpx.txt -t cves/ -severity high,critical` | intermediate | https://github.com/projectdiscovery/nuclei |
| git-hound | GitHub secret and endpoint search | `go install github.com/tillson/git-hound@latest` | `git-hound --subdomain-file subs.txt` | intermediate | https://github.com/tillson/git-hound |
| mass-pii-finder | PII pattern search in files | Check upstream releases | `mass-pii-finder -d ./downloaded-js` | advanced | https://github.com/search?q=mass-pii-finder |
| Agentic-Bug-Hunter | Agentic CLI orchestration of recon tools | Check upstream releases | `abh recon example.com --scope scope.txt` | advanced | https://github.com/search?q=Agentic-Bug-Hunter |
| ARTEX | Self-hosted multi-agent pentest platform with evidence graphs and approval gates | `git clone https://github.com/BaaRai/ARTEX && docker compose up` (see repo) | Configure LLM, set scope, start task with human gates | advanced | https://github.com/BaaRai/ARTEX |
| MCP server (example: filesystem or custom) | Tool interface for AI agents under human control | `npx @modelcontextprotocol/server-filesystem /tmp` or project-specific | Configure in client; never grant unrestricted shell | advanced | https://github.com/modelcontextprotocol/servers |

**Notes**:
- Always verify the current repository URL and license before installing.
- MCP servers expand agent capability; treat third-party servers as untrusted until reviewed (see [[AI-Agentic-Workflows]]).
- For classic pipelines the repository’s existing `init*.sh` / `proced*.sh` scripts remain available.

Related pages: [[AI-Agentic-Workflows]], [[Recon-Methodology]]

<!-- backlinks:auto-start -->

## Backlinks

- [[ai-agentic-workflows\|AI Agentic Workflows]]
- [[home\|Home]]
- [[learning-path\|Learning Path]]
- [[nuclei-templates\|Nuclei Templates]]
- [[recon-methodology\|Recon Methodology]]

<!-- backlinks:auto-end -->
