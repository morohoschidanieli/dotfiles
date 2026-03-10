#!/bin/zsh

# Ensure common paths are in PATH
export PATH="/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin:/opt/homebrew/bin:$PATH"

# Path to Rectangle settings
RECTANGLE_PLIST="$HOME/Library/Preferences/com.knollsoft.Rectangle.plist"
BACKUP_FILE="RectangleConfig.plist"

echo "🪟 Backing up Rectangle shortcuts and settings..."

if [ -f "$RECTANGLE_PLIST" ]; then
    # We use 'defaults' to export it in a clean format
    if defaults export com.knollsoft.Rectangle "$BACKUP_FILE"; then
        echo "✅ Rectangle settings exported to $BACKUP_FILE"
    else
        echo "❌ Failed to export Rectangle settings."
        exit 1
    fi
else
    echo "❌ Rectangle settings not found at $RECTANGLE_PLIST"
    exit 1
fi
