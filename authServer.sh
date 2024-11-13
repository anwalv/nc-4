#!/bin/bash

# Отримуємо IP-адресу клієнта, використовуючи SOCAT_PEERADDR
CLIENT_IP=$SOCAT_PEERADDR

# Файл з даними автентифікації
CREDENTIALS_FILE="/etc/authServer/credentials.txt"

# Перевірка наявності файлу з обліковими даними
if [ ! -f "$CREDENTIALS_FILE" ]; then
  echo "File does not exist!"
  exit 1
fi

# Питання користувачу для введення ключа автентифікації
echo "Enter authorization key for the IP $CLIENT_IP:"
read AUTH_KEY

# Перевірка наявності правильного ключа в файлі credentials.txt
AUTH_MATCH=$(grep "$CLIENT_IP $AUTH_KEY" $CREDENTIALS_FILE)

if [ -n "$AUTH_MATCH" ]; then
  # Якщо ключ вірний, дозволяємо доступ
  echo "Correct!"
  
  # Спочатку видаляємо старі правила iptables для цього IP
  sudo iptables -D INPUT -p tcp --dport 21 -s $CLIENT_IP -j ACCEPT
  sudo iptables -D INPUT -p tcp --dport 21 -s $CLIENT_IP -j REJECT

  # Додаємо нове правило для доступу до FTP
  sudo iptables -I INPUT -p tcp --dport 21 -s $CLIENT_IP -j ACCEPT

  echo "IP $CLIENT_IP added to the list of allowed FTP access."
else
  # Якщо ключ неправильний, заблокувати доступ
  echo "Incorrect!."

  # Видаляємо старі правила iptables для цього IP, якщо вони існували
  sudo iptables -D INPUT -p tcp --dport 21 -s $CLIENT_IP -j ACCEPT
  sudo iptables -D INPUT -p tcp --dport 21 -s $CLIENT_IP -j REJECT

  # Додаємо нове правило для блокування доступу до FTP
  sudo iptables -A INPUT -p tcp --dport 21 -s $CLIENT_IP -j REJECT
fi
