#!/bin/bash

# Update package lists
echo "[+] Updating system..."
sudo apt update && sudo apt upgrade -y

# Install Subfinder for subdomain enumeration
echo "[+] Installing Subfinder..."
go install -v github.com/projectdiscovery/subfinder/v2/cmd/subfinder@latest
export PATH=$PATH:$(go env GOPATH)/bin

# Install Gau for extracting URLs
echo "[+] Installing Gau..."
go install github.com/lc/gau/v2/cmd/gau@latest
export PATH=$PATH:$(go env GOPATH)/bin

# Install wget for downloading JavaScript files
#echo "[+] Installing wget..."
#sudo apt install wget -y

# Install JS Beautifier for cleaning up minified JavaScript
echo "[+] Installing JavaScript Beautifier..."
npm install -g js-beautify

# Install grep for text processing
echo "[+] Installing grep..."
sudo apt install grep -y

echo "[✔] All tools installed successfully!"
echo "[✔] You can now start the JavaScript bug bounty workflow!"
