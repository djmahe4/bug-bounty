# Dorks 
## Google Dorks
- **[Sensitive info leak](https://x.com/darkshadow2bd/status/1964969875996299371)**: ```site:.target.com ( "date of birth" OR confidential OR "internal use only" OR  "bala nce sheet" OR "profit and loss" OR  "banking details" OR  "source code" OR "national id" OR "top secret" ) (ext:pdf OR ext:doc OR ext:ppt OR ext:txt OR ext:csv)```
- **[Sensitive docs](https://x.com/TakSec/status/1970887863987532089)**: ```ext:txt | ext:pdf | ext:xml | ext:xls | ext:xlsx | ext:ppt | ext:pptx | ext:doc | ext:docx
intext:“confidential” | intext:“Not for Public Release” | intext:”internal use only” | intext:“do not distribute” site:example[.]com```
- **[Cloud files leak](https://x.com/TakSec/status/1972693318887686284)**
  ### Drive
  ```
  site:drive.google.com "example[.]com"
  ```
  ### dropbox
  ```
site:dropbox.com/s "example[.]com"
  ```
  ### google docs
  ```
  site:docs.google.com inurl:"/d/" "example[.]com"
  ```
