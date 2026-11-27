# Recon Skill

Operational passive-plus-active reconnaissance pipeline. Wikilink: [[Recon-Methodology]]

## When to use

- Starting work on a newly scoped domain or wildcard.
- Refreshing an existing asset list before a hunting session.
- Producing a prioritized live-host and endpoint set for manual review or template scanning.

## Prerequisites

- Program scope document open and understood.
- Tools installed: subfinder, dnsx, httpx, katana (see [[Tooling-2026]]).
- Output directory prepared (`mkdir -p recon/example.com`).
- Rate-limit and interaction rules noted.

## Workflow

1. Confirm scope. Copy in-scope domains and explicit exclusions into `scope.txt`.
2. Passive subdomain collection:
   ```bash
   subfinder -d example.com -all -recursive -silent -o recon/example.com/subs_subfinder.txt
   ```
3. Optional certificate transparency (respect rate limits):
   ```bash
   curl -s "https://crt.sh/?q=%.example.com&output=json" | jq -r '.[].name_value' | sort -u > recon/example.com/subs_crt.txt
   ```
4. Merge and normalize:
   ```bash
   cat recon/example.com/subs_*.txt | tr '[:upper:]' '[:lower:]' | sort -u > recon/example.com/all_subs.txt
   ```
5. Resolve and filter:
   ```bash
   dnsx -l recon/example.com/all_subs.txt -silent -resp -o recon/example.com/resolved.txt
   ```
6. Probe live hosts:
   ```bash
   awk '{print $1}' recon/example.com/resolved.txt | httpx -silent -title -tech-detect -status-code -content-length -o recon/example.com/httpx.txt
   ```
7. Crawl high-value hosts only:
   ```bash
   head -20 recon/example.com/httpx.txt | awk '{print $1}' | while read u; do katana -u "$u" -jc -silent -d 2; done > recon/example.com/katana.txt
   ```
8. Apply the “when to stop” criteria from [[Recon-Methodology]]. Move to validation or targeted dorking.

## Quality gate

- `all_subs.txt` exists and contains only in-scope names.
- `httpx.txt` has status codes and titles for every live host.
- No out-of-scope hosts appear in the final lists (manual spot-check of 10 random lines).
- Session notes record start time, tools versions, and stop reason.

## Common pitfalls

- Forgetting to normalize case and trailing dots, producing duplicate hosts.
- Running active tools against assets not yet confirmed in scope.
- Ignoring wildcard DNS responses (dnsx helps; still verify).
- Continuing enumeration after new unique results drop to near zero.
- Pasting full tool output into an agent without first applying the scope filter.

## Sources

- https://raw.githubusercontent.com/Cyber-note/Full-Bug-Bounty-Hunting-Methodology-2026/main/README.md
- https://raw.githubusercontent.com/su6osec/Bug-Bounty-Hunting-Methodology-2026/main/README.md
- https://github.com/projectdiscovery/subfinder
- https://github.com/projectdiscovery/httpx
