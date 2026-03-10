#!/bin/bash

# Configuration
RECTANGLE_CONFIG="RectangleConfig.plist"

echo "🪟 Setting up Rectangle..."

# 1. Install Rectangle via Homebrew if missing
if ! brew list --cask rectangle &> /dev/null; then
    echo "   Installing Rectangle via Homebrew..."
    brew install --cask rectangle
else
    echo "   Rectangle is already installed."
fi

# 2. Restore Shortcuts
if [ -f "$RECTANGLE_CONFIG" ]; then
    echo "   Importing Rectangle shortcuts..."
    
    # Close Rectangle first so it doesn't overwrite our import
    killall Rectangle &> /dev/null
    
    # Import settings
    defaults import com.knollsoft.Rectangle "$RECTANGLE_CONFIG"
    
    # Re-open Rectangle
    open -a Rectangle
    echo "✅ Rectangle settings imported!"
else
    echo "⚠️  $RECTANGLE_CONFIG not found in current directory. Run backup first!"
fi

echo "✨ Rectangle setup complete!"
