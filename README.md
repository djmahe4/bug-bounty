# bug-bounty
Bug hunting tools
## Step1: Download
- Use ```git clone https://github.com/djmahe4/bug-bounty/ ```
- Go to bug-bounty folder using```cd bug-bounty ```
- Give execute permissions ```chmod +x * ```
### Windows
- Windows users go to ```/Python ``` directory
## Step2: Initialize
- Execute shellcodes that begins with 'init' to initialize the 'proced' shell code
- Wait for download to complete
### Windows
- Run ```pip install requirements.txt ```
## Step3: Run
- Run the 'proced' shell code to start using ```./ ```
- Enter the domain name to scan
- Wait for the execution to complete
### Windows 
- Run the programs by following the [tutorials](#Python)
## Step4: Analyze
- Click on the urls which seems diverse and look for vulnerabilities (while taking the scope into consideration!)
- Use ai chatbots like grok.com and chat.deepseek.com if necessary
## Step5: Report
- Report the vulnerabilities through bug bounty platforms or direct contact

## Traces

Note!: Please run ```rm *.txt``` after the 'proced' file is executed so that 'tee' commands wont be affected..
--
```init1.sh ``` > ```proced1.sh ``` 
:OSINT-driven reconnaissance with active probing for asset enumeration and vulnerability discovery
### Step 1: Use subfinder, assetfinder, amass, and curl with crt.sh to gather subdomains (passive recon).
### Step 2: Filter and deduplicate with jq, sed, sort, and tee.
### Step 3: Verify live subdomains with httpx (active recon).
### Step 4: Enumerate endpoints with katana and waybackurls (mixed recon).
### Step 5: Manually or automatically analyze the results for vulnerabilities (e.g., exposed reset tokens).
This process is often called a "reconnaissance pipeline" or "attack surface mapping" in security contexts, as it systematically builds a picture of the target’s exposed assets and potential weaknesses.
***
```init2.sh ``` > ```proced2.sh ```
:Used to Build a comprehensive map of the target domain’s attack surface focusing on javascript and secrets 

### Step 1: Enumerate subdomains (subfinder, assetfinder).
### Step 2: Identify live hosts (httpx-pd).
### Step 3: Crawl for endpoints (katana, gospider, waybackurls).
### Step 4: Consolidate and deduplicate URLs (anew).
### Step 5: Focus on JavaScript files (grep, mantra) for deeper analysis.
Outcome: A set of files (subdomains.txt, httpx.txt, allurls.txt, js.txt, mantra.txt) containing potential targets for manual or automated exploitation.
***
```proced3.sh``` 
:Bug hunting methodology devoloped by [Zlatan H](https://www.linkedin.com/in/zlatanh).
```
'"><svg/onload=prompt(5);>{{7*7}}" ==> for Sql injection

"><svg/onload=prompt(5);> ==> for XSS

{{7*7}} ==> for SSTI/CSTI
```
---
```init4.sh ``` > ```proced4.sh ```
: Makes use of Prototype Pollution vulnerability in JavaScript that allows an attacker to manipulate an object's prototype and change the behavior of the entire application. Since JavaScript objects inherit properties from their prototype, modifying the prototype affects all instances of that object type.
### Step 1: Enumerates subdomains using subfinder.

### Step 2: Extracts JavaScript URLs using gau.

### Step 3: Downloads JavaScript files for analysis.

### Step 4: Beautifies JavaScript for easier readability.

### Step 5: Extracts sensitive data like API keys and endpoints.

### Step 6: Performs dynamic testing for vulnerabilities like Prototype Pollution.
[Blog link](https://kongsec.medium.com/js-for-bug-bounties-2-0-extreme-edition-2024-f167fa48276a)
***
```./ip.sh```: Used to find the ip address of the domain 
***
## Python
1. ```wapp_vuln.py ``` => Enter the url to perform fingerprinting and vulnerability lookup using exploit-db.com
2. ```dorking.py ``` => Enter the url to perform dorking using bing
3. ```github_dorking.py ``` => Makes use of [github api](https://github.com/settings/tokens) to perform dorking (Edit the TOKEN variable to the token created from github "with repo permissions only" or manually enter when prompted)
4. ```xss_check.py``` => Performs a basic xss scan using BeautifulSoup, requests and suggest xss payloads
5. ```403_bypass.py``` => Executes  403 (Forbidden) bypass techniques using requests module
---
# OSINT
- [ODIN](https://odin.io/): Find exposed buckets and files
- [Webscout](https://webscout.io/): IP address scanner
- [jimpl](https://jimpl.com): Image metadata extractor (upload profile pic and copypaste url)
# Other Usefull Links
- [Getting Started in Bug Bounty](https://medium.com/@Abhijeet_kumawat_/how-to-start-bug-bounty-in-2025-no-experience-no-problem-89adc68da592?sk=849ceed06612d3111a50f200cd156b1a)
- [Browser Extensions](https://omarora1603.medium.com/top-11-bug-bounty-extensions-that-will-save-you-hours-bea31a368529)
- [Url Scanner](https://cyscan.io/)
- [Web3 Block Explorer](https://dashboard.tenderly.co/explorer)
- [Web Vulnerabilities](https://github.com/KathanP19/HowToHunt/tree/master)
- [API Vulnerabilities](https://github.com/Az0x7/vulnerability-Checklist/tree/main)
- [Bug Bounty](https://bbradar.io/)
- [Security+](https://www.professormesser.com/security-plus/sy0-701/sy0-701-video/sy0-701-comptia-security-plus-course/)
- [NahamSec](https://www.youtube.com/@NahamSec)
- [NullSexX](https://x.com/NullSecurityX)
- [Cyber X List](https://x.com/i/lists/201875823)
## Medium[.]com Topics
- [Bug Bounty](https://medium.com/tag/bug-bounty)
- [Infosec Writeups](https://infosecwriteups.com/)
# SQL Injection
- **Basic SQL Injection**: Explains simple payloads like ```' OR '1'='1``` to bypass login forms by making the query always return true.
- **Union-Based SQL Injection**: Shows how to use UNION to extract data from other tables, e.g., ```' UNION SELECT database(), user(), version() --```.
- **Error-Based SQL Injection**: Demonstrates using errors to reveal database info, like ```' OR 1=CONVERT(int, (SELECT @@version)) --```.
- **Blind SQL Injection**: Covers cases where no direct output is shown, using techniques like ```IF(1=1, SLEEP(5), 0)``` to infer data via delays.
- **Common Payloads**: Lists examples such as ```' DROP TABLE users --``` or ```' AND SUBSTRING((SELECT database()),1,1)='a'```.
