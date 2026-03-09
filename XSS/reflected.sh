subfinder -dL target.txt -all -o subs.txt
httpx -list subs.txt -mc 200,301,302,403 -o alive.txt
katana -list alive.txt -d 5 -jc -kf all -o katana.txt
urlfinder -list alive.txt -all -o urlfinder.txt
cat subs.txt | waybackurls > wayback.txt
cat katana.txt urlfinder.txt wayback.txt | sort -u > all_urls.txt
grep '=' all_urls.txt | sort -u > params.txt
urless -i params.txt -o clean_params.txt
dalfox file clean_params.txt
