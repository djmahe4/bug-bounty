import os
import requests
import zipfile
import subprocess
from selenium import webdriver
from selenium.webdriver.chrome.service import Service


def get_chrome_version():
    """Detect installed Chrome version on Windows."""
    try:
        # Use PowerShell to get Chrome version
        result = subprocess.check_output(
            'powershell -command "& {(Get-Item \\"C:\\Program Files\\Google\\Chrome\\Application\\chrome.exe\\").VersionInfo.ProductVersion}"',
            shell=True, text=True
        )
        return result.strip()
    except Exception as e:
        print(f"Error detecting Chrome version: {e}")
        return None


def download_chromedriver(chrome_version):
    """Download ChromeDriver matching the Chrome version to the current directory."""
    base_url = "https://storage.googleapis.com/chrome-for-testing-public/"
    # Use major version to construct download URL
    major_version = chrome_version.split('.')[0]
    latest_url = f"https://googlechromelabs.github.io/chrome-for-testing/LATEST_RELEASE_{major_version}"

    # Get the exact ChromeDriver version
    response = requests.get(latest_url)
    if response.status_code != 200:
        raise Exception(f"Failed to get latest release for Chrome {major_version}")
    driver_version = response.text.strip()

    # Construct download URL (Windows 64-bit)
    download_url = f"{base_url}{driver_version}/win64/chromedriver-win64.zip"
    driver_path = os.path.join(os.getcwd(), "chromedriver.exe")

    # Download and extract if not already present
    if not os.path.exists(driver_path):
        print(f"Downloading ChromeDriver {driver_version} to {driver_path}...")
        r = requests.get(download_url)
        zip_path = os.path.join(os.getcwd(), "chromedriver.zip")
        with open(zip_path, "wb") as f:
            f.write(r.content)
        with zipfile.ZipFile(zip_path, "r") as zip_ref:
            # Extract chromedriver.exe from the nested folder
            zip_ref.extract("chromedriver-win64/chromedriver.exe")
            os.rename("chromedriver-win64/chromedriver.exe", driver_path)
        os.remove(zip_path)
        os.rmdir("chromedriver-win64")
    else:
        print(f"ChromeDriver already exists at {driver_path}")
    return driver_path


def driver_init():
    """Initialize WebDriver, downloading ChromeDriver if missing."""
    chrome_version = get_chrome_version()
    if not chrome_version:
        raise Exception("Could not determine Chrome version")

    driver_path = download_chromedriver(chrome_version)
    service = Service(executable_path=driver_path)
    options = webdriver.ChromeOptions()
    # Uncomment for headless mode if needed
    options.add_argument("--headless")
    driver = webdriver.Chrome(service=service, options=options)
    return driver

if __name__=="__main__":
    # Main execution with error handling
    try:
        driver = driver_init()
        driver.get("https://example.com")  # Test URL
        print("Page title:", driver.title)
    except Exception as e:
        print(f"An error occurred: {e}")
    finally:
        driver.quit()