#Coded by Zlatan H

echo 'Enter domain name'
read domain
subfinder -d ${domain} -all -recursive subdomain.txt

httpx -l subdomains.txt -ports 80,8080,8000,8888 -threads 200 > subdomains_alive.txt

naabu -list subdomains.txt -c 50 -nmap-cli 'nmap -sV -sC' -o naabu-full.txt

dirsearch -l subdomains_alive.txt -i 200,204,403,443 -x 500,502,429,501,503

-R 5 --random-agent -t 50 -F -w /home/coffinxp/oneforall/onelistforallshort.txt -o directory.txt

cat subdomains_alive.txt | gau > newparms.txt

cat newparms.txt | uro > filterparm.txt

cat filterparam.txt | grep ".js$" > jsfiles.txt

cat jsfiles.txt | while read url; do python3 /home/coffinxp/SecretFinder/SecretFinder.py -i $url -o cli >> secret.txt; done

cat secret.txt | grep aws

cat secret.txt grep google

cat secret.txt grep twilio

cat secret.txt | grep Heroku

nuclei -list newparams.txt -t /home/coffinxp/Custom-Nuclei-Templates
