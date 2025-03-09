from Wappalyzer import Wappalyzer, WebPage
wappalyzer = Wappalyzer.latest()
url=input("Enter url:")
webpage = WebPage.new_from_url(url)
tools=wappalyzer.analyze_with_versions_and_categories(webpage)
print(tools)
for tool in tools:
    try:
        print(tool,tools[tool]['versions'][0],tools[tool]['categories'][0])
    except KeyError:
        print(tool)
    t=""
    for i in tool.split():
        t+=i+"%20"
    print(f"https://vulners.com/search?query={t}")