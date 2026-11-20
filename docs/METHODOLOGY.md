# Bug Bounty Recon Methodology 2026
### Reading Tool Output Like a Pro

> **Core Philosophy**: Running recon tools is easy.  
> **Reading the output** is where the bugs (and the money) are found.

This methodology is distilled from modern 2026 practices (NullSecX "Bug Bounty Recon 2026" and complementary public methodologies). It prioritizes **interpretation of output** over simply collecting data.

---

## 1. Scope First (Non-Negotiable)

Before running any tool:

1. Read the program policy **line by line**.
2. Note:
   - In-scope domains / wildcards
   - Explicitly **out-of-scope** hosts (e.g. `legacy.*`, third-party services)
   - Rate limits
   - Special rules (no automated scanning on certain paths, etc.)

```bash
# Example rate-limit respect (5 rps)
httpx -l hosts.txt -rate-limit 5
nuclei -l hosts.txt -rate-limit 5
ffuf -u https://target.com/FUZZ -rate 5
```

**Rule**: A wildcard (`*.target.com`) is **not** a license to test out-of-scope assets.

---

## 2. Full Recon Pipeline (8 Stages)

### Stage 1 – Organization & Asset Mapping
Map the company before hunting subdomains.

```bash
# ASN ownership
asnmap -d example.com -silent | tee cidrs.txt

# Expand discovered CIDR ranges
mapcidr -l cidrs.txt -silent | tee ips.txt

# Internet-wide indexed asset discovery
uncover -q 'ssl:"example.com"' -e shodan,censys -silent | tee exposed.txt

# Reverse DNS on discovered IP ranges
dnsx -l ips.txt -ptr -resp -silent | tee ptr-records.txt
```

**What to look for**:
- Acquired companies (weaker security)
- Non-standard ports (8443, 9200, etc.)
- Old internal hostnames (jenkins-old, build-server, etc.)

---

### Stage 2 – Subdomain Enumeration

```bash
# Passive (zero traffic to target)
subfinder -d acme-corp.example -all -silent | anew subs.txt

# Permutations
cat subs.txt | alterx -silent | puredns resolve -r resolvers.txt -w wordlist.txt | anew resolved.txt

# Resolve + CNAME analysis
dnsx -l resolved.txt -cname -resp -silent | tee dnsx_out.txt
```

**Critical Output Reading**:
- `CNAME` pointing to unclaimed third-party service → **Subdomain Takeover candidate**
- Wildcard responses → filter them out immediately
- Staging / dev / qa / internal-looking names → higher priority

---

### Stage 3 – Probing (What’s Actually Alive)

```bash
cat resolved.txt | httpx -silent \
  -status-code -title -tech-detect -cdn -follow-redirects \
  -rate-limit 10 | tee live.txt
```

**Status Code Interpretation (Most Important Skill)**

| Code | Meaning                          | Action |
|------|----------------------------------|--------|
| 200  | Alive & serving content          | Normal target |
| 401  | Exists, wants authentication     | Real asset → auth testing |
| 403  | Blocked but resource exists      | Real asset → bypass testing |
| 302 → login | Redirects to login page     | Identifies the product |
| 404 / 0    | Dead or filtered                | Usually ignore |

Also read:
- Page titles
- Technology stack
- Open directory listings (`Index of /`)

```bash
# Port scanning (rate-limited)
naabu -list live.txt -rate 1000 -c 50 -silent | anew ports.txt
nmap -iL interesting_hosts.txt -sV --top-ports 1000 -T3
```
Services:
```
# Identify live HTTP services
httpx -l subs.txt -silent -status-code -title -tech-detect -cdn -follow-redirects -rate-limit 10 | tee live.txt
```

---

### Stage 4 – Content & Endpoint Discovery

```bash
# Historical URLs
gau acme-corp.example --subs | anew allurls.txt
waybackurls acme-corp.example | anew allurls.txt

# Live crawling (JS-aware)
katana -list live.txt -jc -d 3 -silent | anew endpoints.txt

# Directory fuzzing (with auto-calibration)
ffuf -u https://target.com/FUZZ -w /path/to/wordlist.txt \
  -ac -mc 200,204,301,302,307,401,403 -rate 10
```

**Parameter Analysis (High-Value Signals)**

| Parameter Pattern     | Likely Vulnerability     |
|-----------------------|--------------------------|
| `url=`, `uri=`, `path=`, `dest=` | SSRF                    |
| `redirect=`, `next=`, `returnUrl=`, `continue=` | Open Redirect |
| `user_id=`, `id=`, `account=`, `uid=` | IDOR                 |
| `file=`, `path=`, `doc=`         | LFI / Path Traversal   |
| `callback=`, `jsonp=`            | XSS / JSONP issues     |

Always extract parameters:

```bash
cat allurls.txt | grep -oP '[\?&][^=]+=.*' | sort -u
# or use gf patterns
cat allurls.txt | gf ssrf | anew ssrf_candidates.txt
cat allurls.txt | gf idor | anew idor_candidates.txt
cat allurls.txt | gf redirect | anew openredirect_candidates.txt
```

---

### Stage 5 – JavaScript & Source Analysis

```bash
# Collect JS files
cat endpoints.txt | grep -iE '\.js($|\?)' | httpx -silent -mc 200 | anew jsfiles.txt

# Download & analyze
mkdir js_download && cd js_download
cat ../jsfiles.txt | while read url; do wget -q "$url"; done

# Secrets in JS
trufflehog filesystem . --only-verified
# or
gitleaks detect --source . --no-git
```

Look for:
- Hidden API endpoints (never linked in UI)
- Hardcoded API keys / tokens
- Source maps (`.js.map`)
- Feature flags / debug endpoints

---

### Stage 6 – Secrets Hunting

```bash
# GitHub / public repos (careful with rate limits)
trufflehog github --org=acme-corp --only-verified

# Local / cloned repos
trufflehog git file://. --only-verified
gitleaks detect --source . --verbose
```

**Critical Rule**:
- `"Verified: true"` → **STOP**. Prove exposure, report it, **never use the credential**.
- Low entropy / test fixtures → verify context before reporting.

---

### Stage 7 – Triage & Validation

```bash
# Nuclei (templates as leads only)
nuclei -l live.txt -t cves/ -t exposures/ -t misconfiguration/ \
  -severity critical,high,medium -rate-limit 10 -silent | tee nuclei_hits.txt
```

**Mindset**:
> A scanner hit is a **lead**, not a bug.

Always:
1. Reproduce manually in Burp Suite
2. Confirm impact
3. Check if the CNAME is truly unclaimed (for takeovers)
4. Verify the finding is still in scope

---

### Stage 8 – Continuous Monitoring

```bash
# Detect new assets
subfinder -d acme-corp.example -silent | anew subs.txt | notify -provider discord

# Certificate transparency monitoring
# (use tools like certstream, or scheduled subfinder + anew)

# JavaScript change monitoring
# Diff previous JS files against new ones
```

The `+` line from `anew` is the entire point — new assets appear while others sleep.

---

## 3. Prioritization Framework

After collecting thousands of hosts/endpoints, shrink the attack surface to:

1. **Admin / Internal panels**
2. **API endpoints** (especially older versions: `/api/v1`, `/v2`, etc.)
3. **Staging / Dev / QA environments**
4. **Recently changed assets** (new certificates, new JS)
5. **Hosts with interesting technology** (Jenkins, Elasticsearch, Grafana, etc.)

Go **deep** on fewer targets rather than shallow on everything. Business logic bugs live where scanners are blind.

---

## 4. Golden Rules

1. **Scope first, always.**
2. **401 ≠ 403**. Both confirm existence. Treat them differently.
3. **CNAME → Takeover?** Always verify by hand.
4. **Parameter names > paths** for vulnerability hunting.
5. **“Verified: true” = STOP and report.**
6. **Scanner output = lead, not bug.**
7. Monitor continuously — new assets are low-hanging fruit.
8. Stay legal. Stay ethical. Report responsibly.

---

## 5. Recommended Directory Structure for a Target

```bash
target/
├── scope.txt
├── subs.txt
├── resolved.txt
├── live.txt
├── ports.txt
├── allurls.txt
├── endpoints.txt
├── jsfiles.txt
├── secrets/
├── nuclei/
├── interesting/
└── reports/
```

---

## 6. Quick Command Cheat Sheet

```bash
# Full passive → live pipeline (simplified)
subfinder -d target.com -silent | anew subs.txt
cat subs.txt | dnsx -silent -a -resp | anew resolved.txt
cat resolved.txt | httpx -silent -sc -title -tech-detect | anew live.txt

# Parameter mining
cat allurls.txt | gf ssrf idor redirect lfi | anew candidates.txt

# Secrets
trufflehog filesystem . --only-verified
```

---

**Remember**: The hunters who get paid consistently are not the ones who run the most tools.  
They are the ones who understand **what every line of output is actually telling them**.

Happy (and responsible) hunting.

[Source](https://youtu.be/myXCYRPoTy4)
