#!/bin/bash
echo "Enter domain name:"
read dom
# Step 1: Subdomain Enumeration
echo "[+] Enumerating subdomains..."
subfinder -d ${dom} -o subdomains.txt

# Step 2: URL Harvesting for JavaScript Files
echo "[+] Extracting URLs..."
cat subdomains.txt | gau | grep "\.js$" > js_urls.txt

# Step 3: Downloading JavaScript Files
echo "[+] Downloading JavaScript files..."
mkdir js_files
while read url; do
    wget "$url" -P js_files/
done < js_urls.txt

# Step 4: Beautifying JavaScript for Analysis
echo "[+] Beautifying JavaScript files..."
for file in js_files/*.js; do
    js-beautify "$file" -o "$file"
done

# Step 5: Extracting Sensitive Information
echo "[+] Extracting API keys and endpoints..."
grep -E "api_key|token|secret|fetch\(" js_files/*.js > extracted_data.txt

# Step 6: Dynamic Testing for Vulnerabilities
echo "[+] Performing dynamic analysis..."
# Example: Checking for Prototype Pollution
for file in js_files/*.js; do
    if grep -q "__proto__" "$file"; then
        echo "[!] Potential Prototype Pollution in $file"
    fi
done

echo "[+] Workflow completed!"
