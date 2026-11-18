# Report Writing Skill

Structure for HackerOne, Bugcrowd, and Intigriti reports. Wikilink: [[Validation-Skill]]

## When to use

- After the seven-question validation gate has passed.
- When converting confirmed notes into a platform submission.
- When revising a report after triage feedback.

## Prerequisites

- Completed validation notes (all seven questions answered yes).
- Minimal, redacted PoC steps and evidence (screenshots or request/response).
- Program’s required fields and severity guidance open.
- Clean account or test user details ready (never use real customer data).

## Workflow

1. Choose the platform template that matches the program.
2. Write the title in the form: `[Bug class] in [component] allows [attacker] to [impact]`.
3. Fill every section of the template below. Delete placeholder text.
4. Attach only the evidence needed to reproduce; redact tokens and PII.
5. Re-read as a triager: can someone unfamiliar with the target follow the steps in under ten minutes?
6. Submit. Record the report ID and date.

## Quality gate

- Title states class, location, and impact.
- Steps are numbered and use exact requests or UI actions.
- Impact is one concrete sentence, not a generic severity label.
- Evidence is redacted and minimal.
- No out-of-scope assets or excluded bug classes appear.
- Spell-check and platform field requirements satisfied.

## Common pitfalls

- Titles that only name the bug class (“XSS found”).
- Steps that assume the reader already knows the application.
- Impact described as “could lead to account takeover” without showing the path.
- Including exploit payloads that go beyond the proof required.
- Forgetting to mention the exact version, role, or environment tested.

## Filled template (example)

```markdown
Title: IDOR in invoice API allows any authenticated user to read other organizations’ invoices

Asset: api.example.com (in-scope wildcard *.example.com)
Bug class: Broken Object Level Authorization (IDOR)
Severity (self-assessed): High

Summary:
An authenticated user can change the invoice ID in GET /api/v1/invoices/{id} and retrieve invoices belonging to other organizations.

Steps to reproduce:
1. Log in as user A (org 1001).
2. Note a valid invoice ID, e.g. 55001.
3. Send: GET /api/v1/invoices/55002 with user A’s session cookie.
4. Observe HTTP 200 and invoice data for org 1002.

Impact:
Any authenticated user can read financial records of other customer organizations, exposing invoice amounts, line items, and billing contacts.

Evidence:
- Request/response pair (tokens redacted)
- Screenshot of foreign invoice rendered

Remediation suggestion:
Enforce object-level authorization: verify the invoice’s organization matches the authenticated user’s organization before returning data.
```

## Sources

- https://raw.githubusercontent.com/alham-rizvi/Bug-Bounty-Roadmap/main/README.md
- https://raw.githubusercontent.com/su6osec/Bug-Bounty-Hunting-Methodology-2026/main/README.md
- https://docs.hackerone.com/en/articles/8369826-submitting-a-report
