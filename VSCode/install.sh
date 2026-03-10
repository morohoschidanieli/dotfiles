#!/bin/bash

# Configuration
VSCODE_USER_SETTINGS_DIR="$HOME/Library/Application Support/Code/User"
EXTENSIONS_FILE="extensions.txt"
SETTINGS_FILE="settings.json"

echo "🚀 Starting VS Code setup for macOS..."

# Check if 'code' command is available
if ! command -v code &> /dev/null; then
    echo "❌ VS Code CLI 'code' not found. Please install it first:"
    echo "   1. Open VS Code."
    echo "   2. Press Command + Shift + P."
    echo "   3. Type 'Shell Command: Install 'code' command in PATH'."
    exit 1
fi

# 1. Setup settings.json
echo "📂 Setting up settings.json..."
mkdir -p "$VSCODE_USER_SETTINGS_DIR"
if [ -f "$SETTINGS_FILE" ]; then
    cp "$SETTINGS_FILE" "$VSCODE_USER_SETTINGS_DIR/settings.json"
    echo "✅ settings.json copied to $VSCODE_USER_SETTINGS_DIR"
else
    echo "⚠️  $SETTINGS_FILE not found in current directory. Skipping."
fi

# 2. Install extensions
echo "🧩 Installing extensions..."
if [ -f "$EXTENSIONS_FILE" ]; then
    while IFS= read -r extension || [ -n "$extension" ]; do
        # Skip empty lines or comments
        if [[ ! -z "$extension" && ! "$extension" =~ ^# ]]; then
            echo "   Installing: $extension"
            code --install-extension "$extension" --force
        fi
    done < "$EXTENSIONS_FILE"
    echo "✅ All extensions installed!"
else
    echo "⚠️  $EXTENSIONS_FILE not found in current directory. Skipping."
fi

echo "✨ VS Code setup complete!"
