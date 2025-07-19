import time
import csv
import requests
from requests.adapters import HTTPAdapter
from urllib3.util import Retry  # Corrected import name

# Configuration
#DOMAIN = "example.com"  # Replace with your target domain
DOMAIN=input("Enter Domain:")
TOKEN = ""  # Create at: https://github.com/settings/tokens
if TOKEN=="":
  TOKEN=input("Enter token (https://github.com/settings/tokens):")
RESULTS_FILE = "results.csv"
RATE_LIMIT_DELAY = 2  # Seconds between requests

# GitHub API configuration
API_URL = "https://api.github.com/search/code"
HEADERS = {
    "Accept": "application/vnd.github.v3+json",
    "Authorization": f"token {TOKEN}"
}

# Common GitHub dorks for domain searching
DORKS = [
    f'"{DOMAIN}"',
    f'"Token=" "{DOMAIN}"', # Or company name
    f'"{DOMAIN}" password',
    f'"{DOMAIN}" secret',
    f'"{DOMAIN}" api_key',
    f'filename:env "{DOMAIN}"',
    f'filename:docker-compose "{DOMAIN}"',
    f'filename:.git/config "{DOMAIN}"',
    f'filename:.env "{DOMAIN}"',
    f'filename:.bash_history "{DOMAIN}"',
    f'filename:.git-credentials "{DOMAIN}"',
    f'path:wp-config.php "{DOMAIN}"',
    f'extension:sql "{DOMAIN}"',
    f'extension:env "{DOMAIN}"',
]

def setup_session():
    session = requests.Session()
    retry = Retry(  # Corrected class name and syntax
        total=5,
        backoff_factor=1,
        status_forcelist=[500, 502, 503, 504],
        #method_whitelist=["GET"]  # Corrected parameter name,

    )
    adapter = HTTPAdapter(max_retries=retry)
    session.mount("https://", adapter)
    return session


def check_rate_limit(session):
    response = session.get("https://api.github.com/rate_limit", headers=HEADERS)
    if response.status_code == 200:
        limits = response.json()["resources"]["search"]
        return limits["remaining"], limits["reset"]
    return 0, 0


def search_github(session, query):
    results = []
    page = 1
    per_page = 100  # Max allowed per page

    try:
        while True:
            params = {
                "q": query,
                "page": page,
                "per_page": per_page
            }

            response = session.get(API_URL, headers=HEADERS, params=params)

            if response.status_code == 403:
                remaining, reset_time = check_rate_limit(session)
                if remaining == 0:
                    sleep_time = max(reset_time - time.time(), 0) + 10
                    print(f"Rate limit exceeded. Sleeping for {sleep_time} seconds")
                    time.sleep(sleep_time)
                    continue

            response.raise_for_status()

            data = response.json()
            results.extend(data.get("items", []))

            if len(results) >= data.get("total_count", 0) or page * per_page >= 1000:
                break  # GitHub returns max 1000 results per query

            page += 1
            time.sleep(RATE_LIMIT_DELAY)

    except Exception as e:
        print(f"Error searching {query}: {str(e)}")

    return results


def save_results(results):
    with open(RESULTS_FILE, "a", newline="", encoding="utf-8") as csvfile:
        writer = csv.writer(csvfile)

        for item in results:
            writer.writerow([
                item.get("name", ""),
                item.get("path", ""),
                item.get("html_url", ""),
                item["repository"].get("full_name", ""),
                item["repository"].get("html_url", ""),
                item.get("score", "")
            ])


def main():
    session = setup_session()

    # Create CSV header
    with open(RESULTS_FILE, "w", newline="", encoding="utf-8") as csvfile:
        writer = csv.writer(csvfile)
        writer.writerow(["Filename", "Path", "URL", "Repository", "Repo URL", "Score"])

    for dork in DORKS:
        print(f"Searching for: {dork}")
        results = search_github(session, dork)

        if results:
            print(f"Found {len(results)} results for {dork}")
            save_results(results)
            time.sleep(RATE_LIMIT_DELAY)
        else:
            print(f"No results found for {dork}")
# Check rate limits
        remaining, reset = check_rate_limit(session)
        print(f"Remaining requests: {remaining}")
        if remaining < 5:
            sleep_time = max(reset - time.time(), 0) + 10
            print(f"Approaching rate limit. Sleeping for {sleep_time} seconds")
            time.sleep(sleep_time)

if __name__ == "__main__":
    main()
