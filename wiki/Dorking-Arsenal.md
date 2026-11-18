---
title: Dorking Arsenal
category: recon
tags:
- dorking
- google
- shodan
- github
- osint
order: 25
aliases:
- dorks
- dorking
---

# Dorking Arsenal

Operators for Google, Shodan, and GitHub. A result is a lead, not a vulnerability. Always confirm scope and ownership before interaction. See [[Recon-Methodology]] for the surrounding pipeline and [[Nuclei-Templates]] for turning confirmed leads into checks.

## Google

| Dork | Why it works |
|------|--------------|
| `site:example.com filetype:pdf "confidential"` | Indexed documents often contain internal names or endpoints |
| `site:example.com filetype:env` | Environment files may leak keys if accidentally indexed |
| `site:example.com inurl:admin` | Admin paths are frequently left linked |
| `site:example.com intitle:"index of"` | Directory listings expose files |
| `site:example.com ext:sql` | SQL dumps can appear in backups |
| `site:example.com "api_key" OR "apikey"` | Keyword matches in public pages or JS |
| `site:example.com inurl:api/v1` | Versioned API paths |
| `site:example.com filetype:json "password"` | Config or response samples |
| `site:example.com "swagger" OR "openapi"` | API documentation |
| `site:example.com inurl:backup` | Backup directories or files |
| `site:example.com ext:log` | Log files with internal hosts |
| `site:example.com "Authorization: Bearer"` | Example tokens in docs or issues |
| `site:example.com intitle:"login" inurl:staging` | Staging login pages |
| `site:example.com filetype:yml "database"` | CI or config files |
| `site:example.com "TODO" "FIXME" inurl:config` | Developer notes in configs |
| `site:example.com inurl:debug` | Debug endpoints |
| `site:example.com "error" "stack trace"` | Verbose error pages |
| `site:example.com ext:bak` | Backup extensions |
| `site:example.com "firebase" "apiKey"` | Client-side Firebase configs |
| `site:example.com inurl:graphql` | GraphQL endpoints |

## Shodan

| Query | Why it works |
|-------|--------------|
| `org:"Example Corp" http.title:"Dashboard"` | Organization filter plus title finds internal tools |
| `product:"Jenkins" org:"Example"` | Exposed CI servers |
| `product:"MongoDB" "authentication":false` | Unauthenticated databases |
| `product:"Elasticsearch" port:9200` | Open search clusters |
| `product:"Redis" port:6379` | Open Redis instances |
| `http.html:".env"` | HTML containing env-file content |
| `ssl.cert.subject.cn:example.com` | Certificate-linked hosts |
| `http.favicon.hash:123456` | Favicon hash for tech fingerprint |
| `product:"GitLab" port:80` | Exposed GitLab |
| `product:"Kibana"` | Exposed Kibana |
| `port:2375 product:"Docker"` | Unauthenticated Docker API |
| `http.title:"phpMyAdmin"` | Database admin panels |
| `product:"Apache" version:"2.4.49"` | Version-specific known issues |
| `http.html:"index of /"` | Directory listings |
| `org:"Example" port:3389` | Remote desktop exposure |
| `product:"SonarQube"` | Code-quality servers with source |
| `http.component:"WordPress"` | CMS footprint |
| `ssl:"Example Corp"` | Broader certificate search |
| `product:"Jira"` | Project-management exposure |
| `http.html:"api_key"` | Pages containing key strings |

## GitHub

| Query | Why it works |
|-------|--------------|
| `org:example "api_key" OR "apikey"` | Secrets in public repos |
| `org:example filename:.env` | Env files committed by mistake |
| `org:example "password" path:config` | Config credentials |
| `org:example extension:json "secret"` | JSON configs |
| `org:example "BEGIN RSA PRIVATE KEY"` | Private keys |
| `org:example filename:id_rsa` | SSH keys |
| `org:example "AKIA" AWS` | AWS access-key prefixes |
| `org:example path:.github/workflows` | CI secrets in logs or files |
| `org:example "mongodb://" OR "postgres://"` | Connection strings |
| `org:example filename:docker-compose.yml` | Service definitions |
| `org:example "TODO security"` | Developer security notes |
| `org:example extension:yml "token"` | Token values in YAML |
| `org:example "internal.example.com"` | Internal hostnames |
| `org:example path:src "api/" ` | Source revealing endpoints |
| `org:example "Authorization" "Bearer"` | Auth examples with real tokens |
| `org:example filename:.git-credentials` | Stored credentials |
| `org:example "slack_webhook"` | Webhook URLs |
| `org:example path:terraform "secret"` | IaC secrets |
| `org:example "firebaseConfig"` | Client configs |
| `org:example extension:pem` | Certificate or key material |

## Dork → bug-class mapping

| Lead type | Typical next check | Possible class |
|-----------|--------------------|----------------|
| Exposed `.env` or key | Confirm validity and scope | Information disclosure / secret leak |
| Admin or debug path | Authentication and authorization tests | Broken access control |
| Unauthenticated DB / Redis / ES | Read-only proof (no data exfil beyond PoC) | Misconfiguration |
| API documentation or GraphQL | Parameter and object-level authorization | IDOR / BOLA |
| Internal hostname in GitHub | Scope check then recon | Attack-surface expansion |
| Directory listing or backup | Content review for secrets | Information disclosure |
| Version-specific Shodan hit | Nuclei or manual version check | Known CVE |

Related pages: [[Recon-Methodology]], [[Nuclei-Templates]]

<!-- backlinks:auto-start -->

## Backlinks

- [[home\|Home]]
- [[recon-methodology\|Recon Methodology]]

<!-- backlinks:auto-end -->
