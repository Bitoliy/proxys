#!/bin/bash
echo "-----------------------------------------------------------------------------"
echo "Оновлення та установка необхідних пакетів"
echo "-----------------------------------------------------------------------------"
sudo apt update && apt upgrade -y
sudo apt install -y snapd
sudo ufw allow 8388/udp
sudo ufw allow 8388/tcp
sudo snap install shadowsocks-libev

echo "-----------------------------------------------------------------------------"
echo "Редагування файлу конфігурації shadowsocks-libev"
echo "-----------------------------------------------------------------------------"
touch /var/snap/shadowsocks-libev/common/etc/shadowsocks-libev/config.json
nano /var/snap/shadowsocks-libev/common/etc/shadowsocks-libev/config.json

echo "Очікування завершення редагування файла"
echo "-----------------------------------------------------------------------------"
echo "Редагування файлу .service"
echo "-----------------------------------------------------------------------------"
SERVICE_FILE="/etc/systemd/system/shadowsocks-libev-server@.service"
echo "[Unit]" > "$SERVICE_FILE"
echo "Description=Shadowsocks-Libev Custom Server Service for %I" >> "$SERVICE_FILE"
echo "Documentation=man:ss-server(1)" >> "$SERVICE_FILE"
echo "After=network-online.target" >> "$SERVICE_FILE"
echo "" >> "$SERVICE_FILE"
echo "[Service]" >> "$SERVICE_FILE"
echo "Type=simple" >> "$SERVICE_FILE"
echo "ExecStart=/usr/bin/snap run shadowsocks-libev.ss-server -c /var/snap/shadowsocks-libev/common/etc/shadowsocks-libev/%i.json" >> "$SERVICE_FILE"
echo "" >> "$SERVICE_FILE"
echo "[Install]" >> "$SERVICE_FILE"
echo "WantedBy=multi-user.target" >> "$SERVICE_FILE"
nano "$SERVICE_FILE"

echo "-----------------------------------------------------------------------------"
echo "Активація та перевірка статусу shadowsocks-libev сервісу"
echo "-----------------------------------------------------------------------------"
systemctl enable --now shadowsocks-libev-server@config
systemctl status shadowsocks-libev-server@config
echo "-----------------------------------------------------------------------------"
echo "Налаштування фаєрволу"
echo "-----------------------------------------------------------------------------"
# Налаштування фаєрволу
iptables -I INPUT -p tcp --dport 8388 -j ACCEPT
iptables -I INPUT -p udp --dport 8388 -j ACCEPT
echo "-----------------------------------------------------------------------------"
echo "Редагування файла /etc/hosts"
echo "-----------------------------------------------------------------------------"
# Редагування файла /etc/hosts
nano /etc/hosts

echo "-----------------------------------------------------------------------------"
echo "Вимкнення фаєрволу"
echo "-----------------------------------------------------------------------------"
ufw disable
# Перезавантаження сервера
reboot
