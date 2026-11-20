---
title: Recon Methodology
category: recon
tags:
- recon
- subfinder
- httpx
- katana
- dnsx
order: 20
aliases:
- recon
---

# Recon Methodology (2026)

Phase-by-phase pipeline from passive subdomain discovery to JavaScript analysis. Commands are the common ProjectDiscovery forms; adjust rate limits and sources to match program rules. See [[Dorking-Arsenal]] for complementary OSINT operators and [[Tooling-2026]] for install lines.

## Phase 1 — Passive subdomain enumeration

Zero interaction with the target infrastructure.

```bash
subfinder -d example.com -all -recursive -silent -o subs_subfinder.txt
echo example.com | assetfinder --subs-only > subs_assetfinder.txt
# Certificate transparency (one-liner; respect rate limits)
curl -s "https://crt.sh/?q=%.example.com&output=json" | jq -r '.[].name_value' | sort -u > subs_crt.txt
```

Merge and deduplicate:

```bash
cat subs_*.txt | tr '[:upper:]' '[:lower:]' | sort -u > all_subs.txt
```

## Phase 2 — Active probing and resolution

```bash
# DNS resolution with wildcard filtering
dnsx -l all_subs.txt -silent -resp -o resolved.txt

# Live HTTP probing with tech and title
cat resolved.txt | awk '{print $1}' | httpx -silent -title -tech-detect -status-code -content-length -o httpx.txt

# Optional port scan on high-value hosts only (scope-checked)
# naabu -l high_value.txt -top-ports 100 -silent | httpx -silent -o ports_httpx.txt
```

## Phase 3 — Infrastructure mapping

```bash
# ASN / CIDR (example with asnmap if available)
# asnmap -d example.com -silent

# PTR reverse on a known CIDR (only if in scope)
# echo 203.0.113.0/24 | dnsx -silent -resp-only -ptr > ptrs.txt
```

Document ownership evidence before expanding beyond the program’s listed assets.

## Phase 4 — JavaScript and endpoint analysis

```bash
# Crawl with JS extraction
katana -u https://example.com -jc -silent -d 2 -o katana.txt

# Extract endpoints from collected JS
cat katana.txt | grep -E '\.js$' | httpx -silent -o js_live.txt
# Then manually or with tools review for API routes, keys, and internal hosts
```

## When to stop

Stop a recon phase when any of the following is true:

- New unique live hosts or endpoints per additional 15 minutes drop below 2.
- You have covered the program’s listed assets plus obvious certificate and GitHub signals.
- Rate-limit or scope warnings appear.
- You have a short prioritized list (live hosts + interesting endpoints) ready for manual review or template scanning.

Further expansion usually yields duplicates or out-of-scope assets. Move to validation or targeted dorking ([[Dorking-Arsenal]]) instead of endless enumeration.

Related pages: [[Dorking-Arsenal]], [[Tooling-2026]]

<!-- backlinks:auto-start -->

## Backlinks

- [[dorking-arsenal\|Dorking Arsenal]]
- [[home\|Home]]
- [[learning-path\|Learning Path]]
- [[nuclei-templates\|Nuclei Templates]]
- [[tooling-2026\|Tooling 2026]]
- [[validation-skill\|Validation Skill]]

<!-- backlinks:auto-end -->
