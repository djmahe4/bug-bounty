#!/usr/bin/env bash
set -euo pipefail

# === CONFIG ===
TARGET="$1"  # e.g. sub.target.com
WORDLIST="/usr/share/seclists/Discovery/Web-Content/common.txt"
SUBLIST="/usr/share/seclists/Discovery/DNS/subdomains.txt"
THREADS=5

mkdir -p results/$TARGET
cd results/$TARGET

echo "[*] Gathering historical URLs..."
waybackurls "$TARGET" | anew wayback.txt

echo "[*] Filtering for possible broken directories..."
grep -Eo 'https?://[^/]+/[^?#]+' wayback.txt \
  | sort -u \
  | grep -vE '\.(png|jpg|jpeg|gif|css|ico)$' \
  > dirs.txt

echo "[*] Running dirsearch on each directory..."
while read -r dir; do
  dirsearch -u "$dir" -w "$WORDLIST" -t "$THREADS" -x 404,400,500 \
    --plain-text-report=dirsearch.txt || true
done < dirs.txt

echo "[*] Extracting 403 Forbidden hits..."
grep "403" dirsearch.txt | awk '{print $1}' | sort -u > forbidden.txt

echo "[*] Attempting 403 bypass via subdomain fuzzing..."
while read -r url; do
  path=$(echo "$url" | cut -d/ -f4-)
  ffuf -u "https://FUZZ.$TARGET/$path" \
       -w "$SUBLIST" -mc 200 -r \
       -of csv -o ffuf_bypass.csv || true
done < forbidden.txt

echo "[*] Gathering JS files from accessible dirs..."
grep -E "\.js$" dirsearch.txt | awk '{print $1}' | sort -u > js_files.txt

echo "[*] Extracting possible secrets from JS..."
while read -r js; do
  echo "[+] $js"
  curl -s "$js" | \
    grep -Eo '(https?://[^\"]+)|(AKIA[0-9A-Z]{16})|([A-Za-z0-9_-]{20,}\.[A-Za-z0-9_-]{20,}\.[A-Za-z0-9_-]{20,})'
done < js_files.txt > secrets.txt

echo "[*] Done. Results in results/$TARGET/"
