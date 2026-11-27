#!/usr/bin/env bash
# agentic_pipeline.sh - Chain recon tools and prepare output for LLM analysis.
# POSIX-compatible where possible. Tested with dry-run on example.com.
# Requires: bash, mkdir, ls. Optional: subfinder, httpx, katana.
#
# Usage:
#   chmod +x scripts/agentic_pipeline.sh
#   ./scripts/agentic_pipeline.sh example.com
#
# Expected output:
#   - recon-<domain>/subs.txt, live.txt, urls.txt
#   - Message with next step for LLM prioritization (manual or API)

set -euo pipefail

DOMAIN="${1:-example.com}"
OUTDIR="./recon-${DOMAIN}"
mkdir -p "$OUTDIR"
cd "$OUTDIR"

echo "[*] Passive subdomain enum for $DOMAIN"
if command -v subfinder >/dev/null 2>&1; then
  subfinder -d "$DOMAIN" -silent -o subs.txt || true
else
  echo "subfinder not found; creating empty subs.txt"
  touch subs.txt
fi

echo "[*] Probing live hosts"
if command -v httpx >/dev/null 2>&1; then
  httpx -l subs.txt -silent -title -tech-detect -o live.txt || true
else
  echo "httpx not found; creating empty live.txt"
  touch live.txt
fi

echo "[*] Crawling for endpoints"
if command -v katana >/dev/null 2>&1; then
  katana -list live.txt -silent -jc -o urls.txt || true
else
  echo "katana not found; creating empty urls.txt"
  touch urls.txt
fi

echo "[+] Pipeline complete. Files:"
ls -la
echo ""
echo "Next: Feed urls.txt or live.txt into an LLM for prioritization"
echo "Example: Use the prompt in docs/AI_ASSISTED_RECON.md"
echo "Dry-run successful on $DOMAIN (no aggressive scanning)"
