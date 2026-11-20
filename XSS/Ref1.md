# Reflected XSS via DOM Sink (innerHTML)

Look for input written into innerHTML, outerHTML, or document.write() without sanitization.

Test payload: `<img src=x onerror=alert(document.domain)>`

If it fires, it's DOM-based Reflected XSS → session hijack / token theft

[cite](https://x.com/Zerodaylabowner/status/2123654620383703257?a=QTfivoNtiiWvrurDj9o&s=19)
