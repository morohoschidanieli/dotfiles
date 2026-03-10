#!/bin/bash

# Ensure common paths are in PATH
export PATH="/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin:/opt/homebrew/bin:$PATH"

# Configuration
RECTANGLE_CONFIG="RectangleConfig.plist"

echo "🪟 Setting up Rectangle..."

# 1. Install Rectangle via Homebrew if missing
if ! command -v brew &> /dev/null; then
    echo "❌ Homebrew not found. Please install Homebrew first."
    exit 1
fi

if ! brew list --cask rectangle &> /dev/null; then
    echo "   Installing Rectangle via Homebrew..."
    if ! brew install --cask rectangle; then
        echo "❌ Failed to install Rectangle via Homebrew."
        exit 1
    fi
else
    echo "   Rectangle is already installed."
fi

# 2. Restore Shortcuts
if [ -f "$RECTANGLE_CONFIG" ]; then
    echo "   Importing Rectangle shortcuts..."
    
    # Close Rectangle first so it doesn't overwrite our import
    killall Rectangle &> /dev/null
    
    # Import settings
    if defaults import com.knollsoft.Rectangle "$RECTANGLE_CONFIG"; then
        echo "✅ Rectangle settings imported!"
    else
        echo "❌ Failed to import Rectangle settings."
        exit 1
    fi
    
    # Re-open Rectangle
    if open -a Rectangle; then
        echo "✨ Rectangle re-opened!"
    else
        echo "⚠️  Failed to re-open Rectangle automatically."
    fi
else
    echo "⚠️  $RECTANGLE_CONFIG not found in current directory. Run backup first!"
    exit 1
fi

echo "✨ Rectangle setup complete!"
