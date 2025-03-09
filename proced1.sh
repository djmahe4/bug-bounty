echo "Enter domain url"
read dom
subfinder -d $dom | tee subdomains.txt
assetfinder --subs-only $dom | tee -a subdomains.txt
amass enum -passive -d $dom | tee -a subdomains.txt
curl -s "https://crt.sh/?q=%25.${dom}&output=json" > output.json
jq -r ".[].name_value" output.json | sed "s/\*\.//g" | sort -u | tee -a subdomains.txt
sort -u subdomains.txt -o subdomains.txt
cat subdomains.txt | httpx-pd -o live_subdomains.txt
katana -l live_subdomains.txt -o endpoints.txt
cat live_subdomains.txt | waybackurls | tee -a urls.txt
