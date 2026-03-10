#!/bin/zsh

# Path to Rectangle settings
RECTANGLE_PLIST="$HOME/Library/Preferences/com.knollsoft.Rectangle.plist"
BACKUP_FILE="RectangleConfig.plist"

echo "🪟 Backing up Rectangle shortcuts and settings..."

if [ -f "$RECTANGLE_PLIST" ]; then
    # We use 'defaults' to export it in a clean format
    defaults export com.knollsoft.Rectangle "$BACKUP_FILE"
    echo "✅ Rectangle settings exported to $BACKUP_FILE"
else
    echo "❌ Rectangle settings not found at $RECTANGLE_PLIST"
fi
