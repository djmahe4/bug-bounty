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

echo "Installing httpx..."
go install -v github.com/projectdiscovery/httpx/cmd/httpx@latest
mv /usr/local/bin/httpx /usr/local/bin/httpx-pd

# Set GOBIN to /usr/local/bin for Go-based tools
export GOBIN=/usr/local/bin

# Install Go-based tools directly to /usr/local/bin
echo "Installing subfinder..."
go install -v github.com/projectdiscovery/subfinder/v2/cmd/subfinder@latest

echo "Installing assetfinder..."
go install -v github.com/tomnomnom/assetfinder@latest

echo "Installing katana..."
go install -v github.com/projectdiscovery/katana/cmd/katana@latest

echo "Installing waybackurls..."
go install -v github.com/tomnomnom/waybackurls@latest

echo "Installing gospider..."
go install -v github.com/jaeles-project/gospider@latest

echo "Installing anew..."
go install -v github.com/tomnomnom/anew@latest

echo "Installing mantra..."
go install -v github.com/Brosck/mantra@latest

# Install additional dependencies if not present
if ! command -v sed &> /dev/null; then
    echo "Installing sed..."
    apt update
    apt install -y sed
fi

# Create symlinks for standard tools in /usr/local/bin
for tool in sed tee grep; do
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

