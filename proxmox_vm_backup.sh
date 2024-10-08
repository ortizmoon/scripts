#!/bin/bash

# Congiguration
NODE="<node-name>"                  # Proxmox node name
STORAGE="<storage/for/backup>"      # Storage for backups
LOGFILE="/var/log/proxmox_backup.log"

VM_IDS=(                            #ID VMs for backup
    "100"
    "101"
    "102"
    "103"
    "104"
    "105"
    "106"
    "107"
    "108"
    "109"
    "110"
)

# Stop and back up the virtual machine
stop_vm() {
    local vmid="$1"
    echo "$(date) - Stopping VM $vmid..." >> "$LOGFILE"
    qm shutdown "$vmid"
}

backup_vm() {
    local vmid="$1"
    echo "$(date) - Starting backup for VM $vmid..." >> "$LOGFILE"
    if vzdump "$vmid" --node "$NODE" --mode stop --storage "$STORAGE" >> "$LOGFILE" 2>&1; then
        echo "$(date) - Backup completed for VM $vmid. Starting VM..." >> "$LOGFILE"
        qm start "$vmid"
    else
        echo "$(date) - Backup failed for VM $vmid. Starting VM anyway..." >> "$LOGFILE"
        qm start "$vmid"
    fi
}

# Main process
echo "$(date) - Backup process started." >> "$LOGFILE"
for vmid in "${VM_IDS[@]}"; do
    stop_vm "$vmid"
    backup_vm "$vmid"
done
echo "$(date) - Backup process completed." >> "$LOGFILE"
