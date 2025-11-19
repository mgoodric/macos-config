#!/usr/bin/env bash
# post-icloud-setup.sh
# Run this script AFTER signing into iCloud

echo "⚙️  Configuring iCloud-dependent settings..."

# Check if signed into iCloud
if ! defaults read MobileMeAccounts Accounts 2>/dev/null | grep -q "AccountID"; then
    echo "⚠️  Warning: You may not be signed into iCloud yet."
    echo "   Please sign in to iCloud before running this script for best results."
    read -p "Continue anyway? (y/n) " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        exit 1
    fi
fi

###############################################################################
# iCloud Settings                                                             #
###############################################################################

# Enable iCloud Desktop & Documents sync
defaults write com.apple.finder FXICloudDriveEnabled -bool true
defaults write com.apple.finder FXICloudDriveDesktop -bool true
defaults write com.apple.finder FXICloudDriveDocuments -bool true

echo "✅ iCloud settings configured"

# Restart Finder to apply changes
killall Finder

echo "✅ Done! Finder has been restarted to apply changes."
