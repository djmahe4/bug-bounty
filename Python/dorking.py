from urllib.parse import urlparse
from selenium import webdriver
from selenium.webdriver.chrome.service import Service
from webdriver_manager.chrome import ChromeDriverManager
from selenium.webdriver.chrome.options import Options
from selenium.common.exceptions import NoSuchElementException, TimeoutException
from selenium.webdriver.common.by import By
import re
import time
from driver_init import driver_init
from selenium.common.exceptions import StaleElementReferenceException

def safe_click(driver,result):
    attempts = 0
    while attempts < 3:
        try:
            element = result.find_element(By.TAG_NAME, "a").get_attribute("href")
            return element
        except StaleElementReferenceException:
            attempts += 1
            driver.refresh()

url=input("Enter url:")
if url=="":
    url = "https://www.example.com/"
parsed_url = urlparse(url)
domain = parsed_url.netloc.lstrip('www.')
print(domain)
driver = driver_init()
queries = [f'site:{domain} inurl:register.php',f'site:{domain} inurl:portal.php',f'site:{domain} intxt:login',
           f'site:{domain} inurl:login.php',f'site:{domain} filetype:wsdl',f'site:{domain} filetype:swf',
           f'site:{domain} filetype:aspx',f'site:{domain} filetype:php',f'site:{domain} inurl:php?book=',
           f'site:{domain} inurl:php?user=',f'site:{domain} inurl:php?id=',f'site:{domain} intext:"index of/"',
           f"site:{domain} filetype:txt", f"site:{domain} inurl:.php.txt", f"site:{domain} ext:txt",
           f'site:http://s3.amazonaws.com "{domain}"',
           f'site:http://blob.core.windows.net "{domain}"',
           f'site:http://googleapis.com "{domain}"',
           f'site:http://drive.google.com "{domain}"']
for query in queries:
    #driver.get("https://www.bing.com/search?q="+query.replace(' ', '+').replace(":","%3A"))
    #print("https://www.bing.com/search?q="+query.replace(' ', '+').replace(":","%3A"))
    driver.get('https://www.bing.com')
    time.sleep(5)
    search_box = driver.find_element(By.ID, 'sb_form_q')
    search_box.send_keys(query)
    search_box.submit()
    driver.implicitly_wait(10)

    #print(driver.page_source)
    #break
    results = driver.find_elements(By.CSS_SELECTOR, "li.b_algo")[:10]
    #results = driver.find_elements(By.TAG_NAME, 'a')
    for result in results:
        try:
            link = safe_click(driver,result)#result.find_element(By.TAG_NAME, "a").get_attribute("href")
            print(link)

            #print(result.get_attribute('href'))
        except NoSuchElementException:
            print("No link found in this result.")
    time.sleep(2)
driver.close()
