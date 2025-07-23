# 🔍 Bug Hunting Methodology: Finding XSS using Web Archive


---

## Step 1: Identify a Target Domain

Choose the domain you want to test.
Example: redacted.com



---

## Step 2: Use Web Archive (Wayback Machine)

Go to: ```https://web.archive.org```

Search for the target domain to see its historical snapshots.



---

## Step 3: Browse Archived URLs

Navigate through the "URL" section or snapshot dates.

Look for archived pages that contain query parameters (i.e., URLs with ?param=value).



---

## Step 4: Identify Suspicious Parameters

Look for parameters commonly associated with redirection or script injection. Examples:

callback, redirect, url, next, return, target, data, src, etc.


Example:

```https://redacted.com/endpoint?callbackUrl=```



---

## Step 5: Test for Open Redirect or XSS

Open Redirect Test: Try appending a different domain to see if it redirects:

```?callbackUrl=https://evil.com```

XSS Test: Try inserting a simple XSS payload such as:

```?callbackUrl=javascript:alert(document.cookie)```

Observe if the browser executes the payload instead of rejecting or escaping it.



---

## Step 6: Confirm the Vulnerability

If JavaScript payloads are executed, it confirms a stored or reflected XSS.

If redirection happens to external sites, it confirms an open redirect vulnerability.



---

## Step 7: Document the Findings

Include the following in your report:

Vulnerable parameter name and example URL

Payload used

Proof of Concept (screenshots, video, HAR file)

Impact assessment (e.g., token theft, session hijack)

Suggested remediation



---

# ✅ Key Takeaways

Web Archive is a goldmine: old versions of sites often expose outdated and vulnerable endpoints.

Parameters like callbackUrl, redirect, and next are prime targets for testing.

Always test responsibly and ethically. Obtain permission if not part of a bug bounty or responsible disclosure program.
