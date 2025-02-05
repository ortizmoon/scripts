@echo off
setlocal

REM Download directory
set "downloadDir=C:\install"

REM Create download directory if not exist
if not exist "%downloadDir%" (
    mkdir "%downloadDir%"
)

REM Set URLs packages before start script
set "smartmontoolsUrl=https://downloads.sourceforge.net/project/smartmontools/smartmontools/7.4/smartmontools-7.4-1.win32-setup.exe"
set "zabbixAgentUrl=https://cdn.zabbix.com/zabbix/binaries/zabbix_agent2-6.4.5-windows-amd64-openssl.msi"


REM Download files
curl -L -o "%downloadDir%\smartmontools.exe" "%smartmontoolsUrl%"
curl -L -o "%downloadDir%\zabbix_agent2.msi" "%zabbixAgentUrl%"

REM Set paths of downloaded files
set "smartmontoolsPath=%downloadDir%\smartmontools.exe"
set "zabbixAgentPath=%downloadDir%\zabbix_agent2.msi"

REM Install
"%smartmontoolsPath%" /S
msiexec -i "%zabbixAgentPath%" /qn SERVER=<zabbix-server-ip> SERVERACTIVE=<zabbix-server-ip>

REM Stop Zabbix Agent service
net stop "Zabbix agent 2"

REM Configure Zabbix Agent
REM VERY IMPORTANT SET ENCODE ASCII FOR zabbix_agent2.conf !!!
echo Plugins.Smart.Path="C:\Program Files\smartmontools\bin\smartctl.exe">>"C:\Program Files\Zabbix Agent 2\zabbix_agent2.d\plugins.d\smart.conf"
cd "C:\Program Files\Zabbix Agent 2\"
powershell -Command "(gc zabbix_agent2.conf) -replace '# Timeout=3', 'Timeout=20' | Out-File -Encoding ASCII zabbix_agent2.conf"

REM Start Zabbix Agent service
net start "Zabbix agent 2"

REM Remove downloaded files after install
rd /s /q "%downloadDir%"

endlocal