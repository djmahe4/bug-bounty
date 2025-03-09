echo "Enter domain url"
read dom
subfinder -d $dom | tee subdomains.txt
assetfinder --subs-only $dom | tee -a subdomains.txt
cat subdomains.txt | httpx-pd -o httpx.txt
katana -u httpx.txt -o katana.txt
cat httpx.txt | waybackurls >> wayback.txt
gospider -S httpx.txt | sed -n 's/.*\(https:\/\/[^ ]*\)]*.*/\1/p' >> gospider.txt
cat katana.txt gospider.txt wayback.txt >> urls.txt
cat urls.txt | anew >> allurls.txt
cat allurls.txt | grep -E "\.js" >> js.txt
cat js.txt | mantra | tee -a mantra.txt
#echo js.txt
