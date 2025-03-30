echo "Enter domain:"
read dom
result=$(nslookup ${dom} | tail -n 2)
output=${result:8:-1}
echo "$output"