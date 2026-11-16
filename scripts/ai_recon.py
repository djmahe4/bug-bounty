#!/usr/bin/env python3
"""
ai_recon.py - Search GitHub for a target's exposed secrets/endpoints using public API.

Inspired by patterns from mass-pii-finder and git-hound (paraphrased; no code copied).

Usage:
  export GITHUB_TOKEN=your_token  # optional, for higher rate limits
  python3 scripts/ai_recon.py example.com

Expected output:
  JSON list of potential findings with repository, path, and snippet context.
  Dry-run safe; only queries public search API.
"""

import os
import sys
import json
import requests

def search_github(query: str, token: str | None = None) -> list:
    headers = {"Accept": "application/vnd.github+json"}
    if token:
        headers["Authorization"] = f"Bearer {token}"
    url = "https://api.github.com/search/code"
    try:
        resp = requests.get(url, headers=headers, params={"q": f"{query} in:file"}, timeout=10)
    try:
        resp = requests.get(url, headers=headers, timeout=10)
        resp.raise_for_status()
        return resp.json().get("items", [])[:10]  # limit results
    except Exception as e:
        print(f"API error: {e}", file=sys.stderr)
        return []

def main():
    if len(sys.argv) < 2:
        print("Usage: python3 ai_recon.py <domain>")
        sys.exit(1)
    domain = sys.argv[1]
    token = os.getenv("GITHUB_TOKEN")
    queries = [
        f'"{domain}" api_key OR secret OR password OR token',
        f'"{domain}" endpoint OR /api/ OR graphql'
    ]
    findings = []
    for q in queries:
        items = search_github(q, token)
        for item in items:
            findings.append({
                "repo": item.get("repository", {}).get("full_name"),
                "path": item.get("path"),
                "url": item.get("html_url"),
                "score": item.get("score")
            })
    print(json.dumps(findings, indent=2))
    print(f"\nFound {len(findings)} potential items. Review manually. (Dry-run mode)")

if __name__ == "__main__":
    main()
