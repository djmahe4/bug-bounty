# Validation Skill

Seven-question triage gate before report drafting. Wikilink: [[Validation-Skill]]

## When to use

- After any tool hit, dork lead, or manual observation that looks promising.
- Before spending more than 15 minutes on exploitation or PoC polishing.
- When an agent or scanner produces a candidate finding.

## Prerequisites

- Current program scope and out-of-scope list.
- Clean browser profile or fresh session for reproduction.
- Notes from the recon step that produced the lead.
- Access to recent program reports or public write-ups for duplicate checking.

## Workflow

1. Capture the raw observation (URL, request, response snippet, tool output).
2. Answer the seven questions in order. Stop at the first “no”.
   - Reproducible? Repeat from a clean session at least twice.
   - In-scope? Asset listed and bug class not excluded.
   - Exploitable? Demonstrate a concrete action beyond “scanner said so”.
   - Impact? Write one sentence of business or user impact.
   - Duplicate? Search program history and public sources.
   - Safe PoC? Minimal proof; no bulk data access or service disruption.
   - Report-ready? Steps, evidence, and impact understandable to a stranger in under ten minutes.
3. If all seven are “yes”, proceed to the report-writing skill.
4. If any is “no”, document the reason and either discard or return to recon for more context.
5. Record the decision and timestamp in your session notes.

## Quality gate

- Written yes/no for each of the seven questions.
- At least two successful reproductions logged with timestamps.
- One-sentence impact statement present.
- Explicit scope citation (quote or link to the program’s scope page).
- No unanswered “maybe” left in the notes.

## Common pitfalls

- Treating a 200 status or reflected string as sufficient proof of impact.
- Skipping the duplicate check because the bug “looks unique”.
- Expanding the PoC to access more data than needed for demonstration.
- Letting an agent declare a finding valid without human reproduction.
- Reporting version disclosure or missing headers that the program explicitly excludes.

## Sources

- https://raw.githubusercontent.com/su6osec/Bug-Bounty-Hunting-Methodology-2026/main/README.md
- https://raw.githubusercontent.com/alham-rizvi/Bug-Bounty-Roadmap/main/README.md
- https://docs.projectdiscovery.io/templates/introduction
