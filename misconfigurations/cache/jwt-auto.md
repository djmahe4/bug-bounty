## 🛠 How to Use It

1. **Save the script**  
   Copy the code I gave you into a file, e.g.:
   ```bash
   nano jwt-auto.sh
   ```
   Paste it in, save, and make it executable:
   ```bash
   chmod +x jwt-auto.sh
   ```

2. **Get your target’s JWT**  
   - Grab it from a request in Burp, browser dev tools, or your recon scripts.
   - Example:  
     ```
     eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...
     ```

3. **Decide how the token is sent**  
   - **Bearer**: via `Authorization: Bearer <token>` header  
   - **Cookie**: via `Cookie: session=<token>`

4. **Run the script with the right mode**  
   Examples:
   - **Test alg=none**:
     ```bash
     ./jwt-auto.sh -t "$JWT" -u https://target/admin \
       --bearer --claim userType=Admin --none-test --expect-status 200
     ```
   - **Test empty HS256 secret**:
     ```bash
     ./jwt-auto.sh -t "$JWT" -u https://target/me \
       --cookie session --empty-secret-test --expect-text "Welcome"
     ```
   - **Crack HS256 secret with rockyou**:
     ```bash
     ./jwt-auto.sh -t "$JWT" -u https://target/admin \
       --bearer --claim role=admin \
       --wordlist /path/to/rockyou.txt --hashcat --expect-status 200
     ```

5. **Interpret results**  
   - The script prints `STATUS: <code>` and `RESULT: PASS` or `FAIL` based on your expected status/text.
   - If a crack succeeds, it shows the secret and tests a re‑signed elevated token.

---

## ⚙️ What’s Going On Inside

The script automates the **three main misconfig checks** from the article:

| Step | What it Does | Why it Matters |
|------|--------------|----------------|
| **1. alg=none test** | Replaces the JWT header with `{"alg":"none"}` and sends it with no signature. | If the server accepts it, signature verification is disabled — you can forge any claims. |
| **2. Empty HS256 secret** | Signs the token with an empty string as the key. | Some apps misconfigure HS256 to accept a blank secret. |
| **3. HS256 secret cracking** | Uses hashcat (`-m 16500`) or a wordlist loop to brute‑force the signing key offline. | If cracked, you can re‑sign tokens with elevated claims (e.g., `userType=Admin`). |

**Extra touches**:
- **Claim editing**: `--claim key=value` lets you change payload fields before testing.
- **Success detection**: `--expect-status` or `--expect-text` helps avoid false positives.
- **Modes**: Works for both Bearer tokens and cookies.

---

## 🔍 Why This Matches the Write‑Up
In the blog, the tester found:
- The app used **HS256**.
- The signing key was **empty** — no cracking needed.
- By editing the payload (`userType: Admin`) and leaving the signature blank, they got admin and even other users’ accounts.

This script just wraps that manual process into a repeatable, one‑liner workflow — perfect for your recon pipelines.

[WRITEUP LINK](https://gorkaaa.medium.com/bug-bounty-web-cache-deception-cuando-la-cach%C3%A9-filtra-datos-privados-f8f72e6200b5)
