---
title: Nuclei Templates
category: exploitation
tags:
- nuclei
- templates
- yaml
- scanning
order: 30
aliases:
- nuclei
---

# Nuclei Templates

Anatomy of a Nuclei template and three complete, self-contained examples. Always validate before use. See [[Recon-Methodology]] for target lists and [[Tooling-2026]] for the install command.

## Anatomy

```yaml
id: unique-template-id          # required, kebab-case
info:
  name: Human-readable name
  author: your-handle
  severity: info|low|medium|high|critical
  description: What it detects and why
  reference:
    - https://example.com/advisory
  tags: cve,exposure,takeover
  metadata:
    max-request: 1

http:                           # or dns:, tcp:, etc.
  - method: GET
    path:
      - "{{BaseURL}}/path"
    matchers-condition: and
    matchers:
      - type: status
        status:
          - 200
      - type: word
        words:
          - "indicator"
        part: body
    extractors:                 # optional
      - type: regex
        regex:
          - 'version["\s:]+([0-9.]+)'
```

Validate with:

```bash
nuclei -validate -t path/to/template.yaml
```

## Template 1 — CVE version + path matcher (example)

```yaml
id: example-apache-path-version
info:
  name: Example Apache Path and Version Indicator
  author: bug-bounty-wiki
  severity: info
  description: Detects a sample path and version string. Replace with real indicators after research.
  tags: cve,apache,example
  metadata:
    max-request: 1

http:
  - method: GET
    path:
      - "{{BaseURL}}/server-status"
    matchers-condition: and
    matchers:
      - type: status
        status:
          - 200
      - type: word
        words:
          - "Apache Server Status"
          - "Server Version"
        condition: and
        part: body
    extractors:
      - type: regex
        name: version
        part: body
        regex:
          - 'Server Version: Apache/([0-9.]+)'
```

## Template 2 — Fuzzing template for API parameters

```yaml
id: example-api-param-fuzz
info:
  name: Example API Parameter Reflection Check
  author: bug-bounty-wiki
  severity: info
  description: Sends a canary value in common API parameters and checks for reflection. For authorized testing only.
  tags: api,fuzz,example
  metadata:
    max-request: 3

http:
  - method: GET
    path:
      - "{{BaseURL}}/api/v1/users?id={{fuzz}}"
      - "{{BaseURL}}/api/v1/search?q={{fuzz}}"
      - "{{BaseURL}}/api/v1/profile?user={{fuzz}}"
    payloads:
      fuzz:
        - "wiki-canary-12345"
    matchers:
      - type: word
        words:
          - "wiki-canary-12345"
        part: body
```

## Template 3 — Subdomain-takeover CNAME check

```yaml
id: example-subdomain-takeover-cname
info:
  name: Example Subdomain Takeover CNAME Indicator
  author: bug-bounty-wiki
  severity: info
  description: Looks for common unclaimed CNAME targets. Confirm with the provider before reporting.
  tags: takeover,dns,example
  metadata:
    max-request: 1

dns:
  - name: "{{FQDN}}"
    type: CNAME
    matchers-condition: or
    matchers:
      - type: word
        words:
          - "github.io"
          - "herokuapp.com"
          - "s3.amazonaws.com"
          - "azurewebsites.net"
        part: answer
```

These are teaching examples. Replace indicators with verified ones from advisories and re-run `nuclei -validate` before any scan.

Related pages: [[Recon-Methodology]], [[Tooling-2026]]

<!-- backlinks:auto-start -->

## Backlinks

- [[dorking-arsenal\|Dorking Arsenal]]
- [[home\|Home]]
- [[learning-path\|Learning Path]]

<!-- backlinks:auto-end -->
