# Web Security: WAF Evasion Using Weird Characters

Topic: WAF / Command Injection / Input Normalization

This post demonstrates a different kind of filter bypass from the previous Base64 LFI example.

The core idea: Instead of encoding an entire file path using Base64, the attacker disguises a command using shell syntax, escape sequences, hexadecimal encoding, environment variables and wildcard expansion.

The WAF sees an unusual string, while the backend shell may interpret it as a legitimate command.

### 1\. Understanding the attack

The original command is:

```bash
cat /etc/passwd
```

This reads the Linux password-account database.

Suppose a web application accepts a parameter and passes it into a shell command.

A WAF blocks the obvious request:

```text
?param=cat /etc/passwd
```

It might return:

```http
HTTP/1.1 403 Forbidden
```

The attacker then attempts to disguise the command.

### 2\. Techniques used in the screenshot

There are several interesting techniques here.

| Technique          | Example         | Purpose                                                             |
| ------------------ | --------------- | ------------------------------------------------------------------- |
| Backslash escaping | c\\a\\t         | Changes how characters appear before shell interpretation           |
| Hex encoding       | \\x63\\x61\\x74 | Represents characters using hexadecimal escapes                     |
| IFS manipulation   | $IFS            | Uses the shell's Internal Field Separator instead of literal spaces |
| Wildcard expansion | /???/b**h       | Uses glob patterns to resolve executable paths                      |
| Punctuation        | Extra symbols   | Attempts to confuse simplistic pattern matching                     |

Let's understand each.

### A. Backslash escaping

Consider:

```bash
c\a\t
```

In an unquoted Bash command, backslashes can escape the following characters.

The shell removes those escape characters, potentially interpreting the result as:

```bash
cat
```

A WAF searching for the literal string `cat` may fail to recognize the disguised representation.

### B. Hexadecimal escape sequences

The screenshot contains:

```text
\x63\x61\x74\x20\x2f\x65\x74\x63
```

These are hexadecimal character representations.

| Hex   | Character |
| ----- | --------- |
| \\x63 | c         |
| \\x61 | a         |
| \\x74 | t         |
| \\x20 | Space     |
| \\x2f | /         |
| \\x65 | e         |
| \\x74 | t         |
| \\x63 | c         |

Together, they represent:

```bash
cat /etc
```

The important distinction: hexadecimal escapes are not automatically decoded by every web server or shell. Their interpretation depends on the component processing them.

### C. IFS (Internal Field Separator)

Normally, commands use spaces:

```bash
echo -e 'hello'
```

The shell's `$IFS` variable normally contains whitespace characters, including spaces, tabs and newlines.

An attacker can exploit this behavior to construct arguments without typing ordinary spaces.

For example, `$IFS` can act as a separator in an unquoted shell expression.

### D. Wildcard expansion

The screenshot also uses a path resembling:

```text
/???/b**h
```

Shell globbing can expand `?` to one character and `*` to zero or more characters.

Depending on the filesystem, this pattern can resolve to an executable path such as:

```text
/bin/bash
```

This is another way of disguising a command interpreter's location.

### 3\. How the complete attack works

The screenshot's payload is approximately structured like this:

```bash
e\c\h\o$IFS-e$IFS'\x63\x61\x74\x20\x2f\x65\x74\x63\x2f\x70\x61\x73\x73\x77\x64' | /???/b**h
```

Conceptually, the shell processes it as follows:

1\. Obfuscated command name

`e\c\h\o` becomes `echo` after shell escape processing.

2\. Argument separation

`$IFS` supplies whitespace separators.

3\. Hexadecimal decoding

`echo -e` interprets the hexadecimal escapes and produces `cat /etc/passwd`.

4\. Wildcard resolution

The executable path pattern can resolve to a shell such as `/bin/bash`.

5\. Command execution

The generated command is piped into the shell for execution.

The intended result is equivalent to executing:

```bash
cat /etc/passwd
```

The output shown in the screenshot contains entries from the Linux passwd file.

Note: This reconstruction is based on the visible screenshot. Exact execution depends on shell implementation, quoting, glob expansion and the application's command-processing environment. `echo -e` is not universally portable.

### 4\. Why does the WAF fail?

A simplistic WAF might use a signature like:

```regex
cat\s+/etc/passwd
```

It looks for the literal command and path.

But the attacker changes the representation:

* Backslashes hide command names.

* Hexadecimal escapes hide sensitive strings.

* `$IFS` replaces whitespace.

* Wildcards disguise executable paths.

The WAF and shell effectively see different representations of the input.

This is another example of:

Canonicalization mismatch + interpretation mismatch.

### 5\. How to defend against this

This is where the post's recommendation to normalize first becomes important.

| Defensive measure         | What it addresses                 |
| ------------------------- | --------------------------------- |
| Input normalization       | Alternative representations       |
| Repeated escape detection | Suspicious nested encoding        |
| Canonicalization          | Inconsistent input interpretation |
| Allowlisting              | Unexpected parameter formats      |
| WAF signatures            | Known malicious patterns          |
| Process monitoring        | Actual shell execution            |

One important correction to the post's advice:

Do not blindly decode everything repeatedly until stable.

Different layers have different decoding rules. Repeated decoding can itself create vulnerabilities.

Instead:

* Identify the expected encoding and processing layers.

* Decode according to those rules.

* Reject malformed or unexpected encodings.

* Validate the canonical representation.

* Never pass untrusted input into a shell.

For applications that genuinely need subprocesses, prefer direct process execution with argument arrays rather than constructing shell command strings.

### 6\. Connection to other security concepts

| Concept                 | Relationship                                                 |
| ----------------------- | ------------------------------------------------------------ |
| Command Injection       | Attacker influences OS command execution                     |
| WAF Evasion             | Disguises malicious input from security signatures           |
| Canonicalization Attack | Exploits multiple representations of the same input          |
| Shell Expansion         | Variables, escaping and globbing change input interpretation |
| Living-off-the-Land     | Abuse of legitimate system utilities                         |
| Defense in Depth        | WAF + application validation + process monitoring            |

### 7\. Practical detection opportunities (Blue Team)

For SOC/EDR detection, don't rely exclusively on HTTP request signatures.

Look for suspicious process activity:

* Web server spawning `/bin/bash`, `/bin/sh` or other shells.

* Unexpected `echo -e` execution.

* Shell processes receiving piped input.

* Web application processes accessing `/etc/passwd`.

* Unusual child-process relationships.

For example, a process tree like:

```text
nginx
 └── php-fpm
      └── bash
           └── cat
                └── /etc/passwd (access)
```

would warrant investigation, although legitimate administrative applications can also spawn subprocesses.

### 8\. Key takeaway

Previous example vs this example

| Base64 LFI                      | Weird-character WAF evasion     |
| ------------------------------- | ------------------------------- |
| Encodes file path               | Obfuscates shell command        |
| Exploits file inclusion         | Exploits command execution      |
| Depends on application decoding | Depends on shell interpretation |
| Targets file access             | Targets OS command execution    |

Both exploit the same broader weakness: security controls inspect one representation while the application processes another.

A useful knowledgebase classification:

`WAF Evasion → Input Obfuscation → Shell Metacharacters / Encoding / Environment Variable Expansion / Glob Expansion`

This is particularly useful when building a DAST knowledgebase: record not just the payload, but also the transformation that makes it work, the vulnerable execution sink, and the conditions required for successful exploitation.
