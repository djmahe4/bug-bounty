#To make wappalyzer work, run
"""
```commandline
python -m pip install --user pipx
pipx install wappalayzer
```
"""
from Wappalyzer import Wappalyzer, WebPage
wappalyzer = Wappalyzer.latest()
url=input("Enter url:")
webpage = WebPage.new_from_url(url)
tools=wappalyzer.analyze_with_versions_and_categories(webpage)
print(tools)
for tool in tools:
    try:
        print(tool,tools[tool]['versions'][0],tools[tool]['categories'][0])
    except (KeyError,IndexError):
        print(tool)
    t=""
    for i in tool.split():
        t+=i+"%20"
    #print(f"https://vulners.com/search?query={t}")
    print(f"https://www.exploit-db.com/search?q={t}")