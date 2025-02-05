# Set the execution policy for PowerShell scripts
Set-ExecutionPolicy RemoteSigned -Force
# Set-ExecutionPolicy -Scope CurrentUser -ExecutionPolicy Unrestricted -Force # Uncomment to set policy for current user

# Install OpenSSH client and server components
Add-WindowsCapability -Online -Name OpenSSH.Client~~~~0.0.1.0
Add-WindowsCapability -Online -Name OpenSSH.Server~~~~0.0.1.0

# Create a firewall rule
New-NetFirewallRule -Name sshd -DisplayName 'OpenSSH Server (sshd)' -Enabled True -Direction Inbound -Protocol TCP -Action Allow -LocalPort 22

# Autostart service
Start-Service sshd
Set-Service -Name sshd -StartupType Automatic

# Set PowerShell as the default shell for OpenSSH
New-ItemProperty -Path "HKLM:\SOFTWARE\OpenSSH" -Name DefaultShell -Value "C:\Windows\System32\WindowsPowerShell\v1.0\powershell.exe" -PropertyType String -Force
