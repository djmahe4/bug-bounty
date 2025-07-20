echo "Enter organisation name:"
read ORG
gh repo list $ORG --limit 1000 --json url \
  | jq -r '.[].url' \
  > github_repos.txt
# waybackurls
cat github_repos.txt \
  | waybackurls \
  > wayback_github_urls.txt

# gau
cat github_repos.txt \
  | gau --subs \
  > gau_github_urls.txt
echo "your-org.github.io" \
  | hakrawler -plain \
  > crawl_github_pages.txt
cat \
  wayback_urls.txt \
  gau_urls.txt \
  crawl_urls.txt \
  wayback_github_urls.txt \
  gau_github_urls.txt \
  crawl_github_pages.txt \
  | sort -u \
  > urls.txt
sort -u urls.txt -o urls.txt
echo "Top 20"
head -n 20 urls.txt
echo "Working.."
cat urls.txt | grep github.com | awk -F[/] ‘{print $1"//”$3"/”$4}’ | sort | uniq
