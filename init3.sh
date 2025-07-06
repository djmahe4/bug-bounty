#!/bin/bash

# Check if the script is running as root
if [ "$EUID" -ne 0 ]; then
    echo "Please run as root"
    exit 1
fi

# Install Go if not present
if ! command -v go &> /dev/null; then
    echo "Installing Go..."
    apt update
    apt install -y golang
fi

echo "Getting the worldlist.."
wget https://github.com/coffinxp/payloads/blob/c3d5e4e6e744d8ded9fd36163942eaeec15f4fed/onelistforallshort.txt

echo "Installing httpx..."
go install -v github.com/projectdiscovery/httpx/cmd/httpx@latest
mv /go/bin/httpx /usr/local/bin/httpx-pd

echo "Installing uro..."
sudo apt install pipx
pipx install uro

# Set GOBIN to /usr/local/bin for Go-based tools
export GOBIN=/usr/local/bin

# Install Go-based tools directly to /usr/local/bin
echo "Installing subfinder..."
go install -v github.com/projectdiscovery/subfinder/v2/cmd/subfinder@latest

echo "Installing Gau"
go install github.com/lc/gau/v2/cmd/gau@latest

echo "Installing assetfinder..."
go install -v github.com/tomnomnom/assetfinder@latest

echo "Installing amass..."
go install -v github.com/owasp-amass/amass/v3/cmd/amass@latest

echo "Installing katana..."
go install -v github.com/projectdiscovery/katana/cmd/katana@latest

echo "Installing waybackurls..."
go install -v github.com/tomnomnom/waybackurls@latest

echo "Installing naabu..."
sudo apt install -y libpcap-dev
go install -v github.com/projectdiscovery/naabu/v2/cmd/naabu@latest

echo  "Insstalling dirsearch"
git clone https://github.com/maurosoria/dirsearch.git --depth 1
cd dirsearch
apt install python3.13-venv
python3 -m venv venv
chmod +x venv/bin/activate
./venv/bin/activate
venv/bin/pip install -r requirements.txt
cd ..

echo "Installing nuclei..."
go install -v github.com/projectdiscovery/nuclei/v2/cmd/nuclei@latest

# Install jq if not present
if ! command -v jq &> /dev/null; then
    echo "Installing jq..."
    apt update
    apt install -y jq
fi

# Create symlinks for jq and standard tools in /usr/local/bin
for tool in jq curl sed sort tee; do
    tool_path=$(which "$tool")
    if [ -n "$tool_path" ] && [ ! -f "/usr/local/bin/$tool" ]; then
        ln -s "$tool_path" "/usr/local/bin/$tool"
        echo "Created symlink for $tool in /usr/local/bin"
    elif [ -f "/usr/local/bin/$tool" ]; then
        echo "$tool already exists in /usr/local/bin"
    else
        echo "Warning: $tool not found"
    fi
done

echo "All tools installed and configured."
