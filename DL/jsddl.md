# Bug Bounty Technique: From Java Server Identification to Forensic Code Analysis

## 1. Server Identification and Fingerprinting

### Passive Recon  
- Use Subfinder, Amass, or assetfinder to enumerate subdomains.  
- Check DNS records (crt.sh, SecurityTrails) for hidden hostnames.

### Active Recon  
1. Scan HTTP ports (80, 8080, 8443):  
   ```bash
   nmap -sV -p80,8080,8443 --script=http-title,http-server-header target.com
   ```  
2. Fingerprint the stack with WhatWeb or Wappalyzer to detect Tomcat, Jetty, or other Java servers.

---

## 2. Probing Java Web Directories

Common Java endpoints often left in default states:  
- /manager/html (Tomcat manager)  
- /host-manager/html (Tomcat host manager)  
- /docs or /doc (Jetty documentation)  
- /status (Jetty status page)

If any yields HTTP 200, you’ve confirmed a Java web container is present.<br>
Even 403 Unauthorized is taken as a confirmation.<br>
Otherwise use Wappalyzer to check.

---

## 3. Uncovering `/WEB-INF/` and `/META-INF/` Listings

Even when the root returns 403, subdirectories can be exposed. Test for directory listings:

```bash
curl -s 'https://target.com/WEB-INF/' \
  | grep -E 'Index of|\.class'
```

In one bug bounty, a 403 on “/” was bypassed by hitting `/WEB-INF/` and `/META-INF/`, exposing dozens of `.class` files of the backend service.

---

## 4. Automated Retrieval of `.class` Files

Download everything under the exposed directory:

```bash
wget -r -np -nH --cut-dirs=1 -A '.class' \
  https://target.com/WEB-INF/
```

This pulls the compiled bytecode for offline analysis.

---

## 5. Decompiling Java Bytecode

Convert `.class` files back into human-readable Java source:

| Tool                | Command Example                                                           |
|---------------------|-----------------------------------------------------------------------------|
| procyon-decompiler  | `java -jar procyon-decompiler.jar *.class -o decompiled/`                  |
| CFR                 | `java -jar cfr.jar *.class --outputdir decompiled/`                        |
| JADX                | `jadx -d decompiled/ path/to/classes/`                                      |

These decompilers reconstruct classes, methods, and logic flow for deep inspection.

---

## 6. Forensic Code Analysis

With source in hand, hunt for:

- Authentication flaws  
  - Hard-coded credentials or bypass flags in login routines.  
- Sensitive configuration  
  - API keys, database URLs, or private tokens in config classes.  
- Insecure deserialization  
  - `ObjectInputStream`, `readObject()`, or unsafe use of Commons-Collections.  
- Business logic errors  
  - Missing access-control checks, unsafe parameter parsing.  
- Information leakage  
  - Stack traces, debug logs, or verbose error handlers.

---

## 7. Chaining, PoC, and Impact

1. Reproduce each finding in a controlled environment.  
2. Chain credentials or deserialization flaws to achieve RCE.  
3. Create a clear Proof of Concept, capturing HTTP requests, payloads, and responses.  
4. Assess business impact—data exposure, full server compromise, lateral movement.

---
[Credits](https://osintteam.blog/1000-bounty-from-403-to-source-code-28e9a9c572d8)
