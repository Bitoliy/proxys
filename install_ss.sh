#!/bin/bash
echo "-----------------------------------------------------------------------------"
echo " Оновлення та установка необхідних пакетів"
echo "-----------------------------------------------------------------------------"
sudo apt apt update && apt upgrade -y
sudo apt install -y snapd
sudo ufw allow 8388/udp
sudo ufw allow 8388/tcp
sudo snap install shadowsocks-libev
echo "-----------------------------------------------------------------------------"
echo "Редагування файлу конфігурації shadowsocks-libev"
echo "-----------------------------------------------------------------------------"
touch /var/snap/shadowsocks-libev/common/etc/shadowsocks-libev/config.json
nano /var/snap/shadowsocks-libev/common/etc/shadowsocks-libev/config.json
echo "-----------------------------------------------------------------------------"
echo "Редагування файлу .service:"
echo "-----------------------------------------------------------------------------"
touch /etc/systemd/system/shadowsocks-libev-server@.service
nano /etc/systemd/system/shadowsocks-libev-server@.service
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
echo "Редагування фаєрволу"
echo "-----------------------------------------------------------------------------"
ufw disable
# Перезавантаження сервера
reboot
