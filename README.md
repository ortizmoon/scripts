## Scripts collection<br><br>
______
### `install_ssh_windows.ps1`<br>
A simple PowerShell script for automatic SSH installation on Windows hosts.<br>
______
### `install_zabbix_agent_smartmontools.bat`<br>
Automatic installation and configuration Zabbix agent and Smartmontools on Windows hosts. <br>
______
### `install_zabbix_agent_smartmontools.sh`<br>
Automatic installation and configuration Zabbix agent and Smartmontools on Linux hosts.<br>
______
### `backup_proxmox_vm.sh`<br>
Automatic backup of virtual machines on Proxmox servers/clusters.<br>
______
### `install_nginx_proxy.sh`<br>
### Description:
```bash
Automatic installation of Nginx as a reverse proxy with predefined variables, domain name, automatic issuance, and renewal Let’s Encrypt certificates. Recommended to add an A-record with your hosting provider in advance.
```
### Exec:
```bash
./install_nginx_proxy.sh
```
or
```bash
bash <(curl -Ls https://raw.githubusercontent.com/ortizmoon/scripts/master/install_nginx_proxy.sh)
```


______
### `install_proxmox_ve.sh`<br>
Automatic installation of the latest Proxmox VE version on Debian, with predefined variables, in a non-interactive mode, including automatic boot disk selection, automatic mail configuration disabling, automatic creation of a user for PVE authentication, and automatic API token generation. The token file is saved in the home directory of the script’s user.
______