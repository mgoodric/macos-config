#!/usr/bin/env bash
# Temporary script to set up autofs for Unraid shares
# Delete this file after running

set -e

echo "Configuring autofs for Unraid shares..."

UNRAID_IP="192.168.1.246"
MOUNT_POINT="/Volumes/unraid"

# Create the autofs map file for SMB shares
sudo tee /etc/auto_smb > /dev/null <<EOF
# Unraid SMB shares - credentials from macOS keychain
Photography -fstype=smbfs ://${UNRAID_IP}/Photography
Videography -fstype=smbfs ://${UNRAID_IP}/Videography
EOF

# Check if auto_master already has our entry
if ! grep -q "auto_smb" /etc/auto_master; then
    echo "Adding autofs entry to auto_master..."
    # Add our map before the +auto_master line (or at end if not found)
    if grep -q "+auto_master" /etc/auto_master; then
        sudo sed -i '' '/+auto_master/i\
'"${MOUNT_POINT}"'    auto_smb    -nosuid,noowners
' /etc/auto_master
    else
        echo "${MOUNT_POINT}    auto_smb    -nosuid,noowners" | sudo tee -a /etc/auto_master > /dev/null
    fi
fi

# Create mount point directory
sudo mkdir -p "$MOUNT_POINT"

# Restart autofs to apply changes
sudo automount -vc

echo ""
echo "✅ Autofs configured for Unraid shares"
echo "   Shares will be available at:"
echo "   - ${MOUNT_POINT}/Photography"
echo "   - ${MOUNT_POINT}/Videography"
echo ""
echo "Note: Ensure credentials are stored in Keychain Access:"
echo "   - Add a new password item for '${UNRAID_IP}'"
echo "   - Account: your Unraid username"
echo "   - Password: your Unraid password"
echo ""
echo "You can delete this script now: rm setup-autofs-unraid.sh"
