#!/bin/zsh

# Ensure common paths are in PATH
export PATH="/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin:/opt/homebrew/bin:$PATH"

# Get the directory where the script is located
SCRIPT_DIR="${0:A:h}"
cd "$SCRIPT_DIR"

echo "🍺 Updating Homebrew Brewfile..."

if ! command -v brew &> /dev/null; then
    echo "❌ Error: Homebrew is not installed!"
    exit 1
fi

# Dump current packages to Brewfile
# --force: overwrite existing Brewfile
# --describe: add descriptions to the Brewfile
if brew bundle dump --force --describe --file="Brewfile"; then
    echo "✅ Brewfile updated successfully."
else
    echo "❌ Failed to update Brewfile."
    exit 1
fi
