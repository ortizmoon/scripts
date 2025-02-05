#!/bin/bash

log_file="$PWD/zabbix_install.log"
exec > >(tee -a "$log_file") 2>&1

echo "---updating package list---"
apt update

echo "---install zabbix agent2 and smartmontools---"
apt install zabbix-agent2 smartmontools -y

echo "Plugins.Smart.Path=/usr/sbin/smartctl" | tee -a /etc/zabbix/zabbix_agent2.d/plugins.d/smart.conf
zabbix_agent_conf="/etc/zabbix/zabbix_agent2.conf"

echo "---setting up zabbix agent configuration---"
sed -i "s/^Server=.*/Server=<zabbix-server-ip>/" $zabbix_agent_conf
sed -i "s/^ServerActive=.*/ServerActive=<zabbix-server-ip>/" $zabbix_agent_conf

echo "---apply changes---"
systemctl restart zabbix-agent2

echo "---completed---"