#!/bin/bash

if [ -z "$1" ]; then
    echo "You must provide a list of allowed IPs as a comma-separated list."
    exit 1
fi

ALLOWED_IPS=$1

sudo apt update && sudo apt upgrade -y

sudo apt install vsftpd socat iptables -y

sudo systemctl start vsftpd
sudo systemctl enable vsftpd

sudo adduser --disabled-password --gecos "" ftp_user
echo "ftp_user:MyFTPPass!" | sudo chpasswd

echo "Hello World!" | sudo tee /home/ftp_user/1.txt > /dev/null
echo "Hello World!" | sudo tee /home/ftp_user/2.txt > /dev/null

IFS=',' read -ra IP_ARRAY <<< "$ALLOWED_IPS"
for IP in "${IP_ARRAY[@]}"; do
    sudo iptables -A INPUT -p tcp --dport 21 -s $IP -j ACCEPT
done

sudo iptables -A INPUT -p tcp --dport 21 -j DROP

sudo iptables -A INPUT -p icmp -j DROP

sudo cp ./authServer.sh /usr/bin/
sudo chmod +x /usr/bin/authServer.sh

sudo mkdir -p /etc/authServer
sudo cp ./credentials.txt /etc/authServer/

sudo cp ./authServer.service /etc/systemd/system/
sudo systemctl daemon-reload
sudo systemctl enable authServer.service
sudo systemctl start authServer.service

echo "Server configured successfully!"
