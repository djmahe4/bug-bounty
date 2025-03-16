import requests
import time

domain=input("Enter domain:")
#urls=[]
with open("403_bypass.txt","r") as file:
    urls=file.readlines()
    print(f"No of urls: {len(urls)}\n Please take rate limit into consideration and edit the code accordingly!\n")
for url in urls:
    #print(f"https://{domain}/"+"/".join(url.split("/")[1:]))
    e_url=f"https://{domain}"+"/".join(url.split("/")[1:])
    response=requests.get(e_url)
    if response.status_code==200:
        print(f"SUCCESS!: {e_url}")
    time.sleep(1)