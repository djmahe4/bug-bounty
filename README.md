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
- Run the programs by folowing the [tutorials]()
## Step4: Analyze
- Click on the urls which seems diverse and look for vulnerabilities (while taking the scope into consideration!)
- Use ai chatbots like grok.com and chat.deepseek.com if necessary
## Step5: Report
- Report the vulnerabilities through bug bounty platforms or direct contact

## Traces
```init1.sh ``` > ```proced1.sh ``` 
### Step 1: Use subfinder, assetfinder, amass, and curl with crt.sh to gather subdomains (passive recon).
### Step 2: Filter and deduplicate with jq, sed, sort, and tee.
### Step 3: Verify live subdomains with httpx (active recon).
### Step 4: Enumerate endpoints with katana and waybackurls (mixed recon).
### Step 5: Manually or automatically analyze the results for vulnerabilities (e.g., exposed reset tokens).
This process is often called a "reconnaissance pipeline" or "attack surface mapping" in security contexts, as it systematically builds a picture of the target’s exposed assets and potential weaknesses.
---
## Python
1. ```wapp_vuln.py ``` => Enter the url to perform fingerprinting and vulnerabilty lookup using vulners.com
2. ```dorking.py ``` => Enter the url to perform dorking using bing
