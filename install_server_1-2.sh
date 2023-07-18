#!/bin/bash

# Оновлення та установка необхідних пакетів
apt update && apt upgrade -y
apt install -y snapd
# Після перезавантаження
sudo apt update
sudo apt install apt-transport-https ca-certificates curl software-properties-common
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
echo "deb [arch=amd64 signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt update
sudo apt install docker-ce docker-ce-cli containerd.io
sudo systemctl start docker

# Завантаження і запуск контейнера з проксі
wget http://fjedi.com/init_server.sh
chmod +x init_server.sh
./init_server.sh

# Редагування файлу docker-compose.yml
nano docker-compose.yml

# Запуск контейнера
docker-compose up -d

# Перезавантаження сервера
reboot
