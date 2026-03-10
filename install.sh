#!/bin/bash

# Get the absolute path of the directory where the script is located
DOTFILES_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

echo "🚀 Starting Master Installation Script..."

# Function to run a script in its directory
run_script() {
    local dir=$1
    local script=$2
    if [ -d "$DOTFILES_DIR/$dir" ]; then
        echo ""
        echo "------------------------------------------"
        echo "📂 Running $dir/$script..."
        echo "------------------------------------------"
        cd "$DOTFILES_DIR/$dir" || exit
        chmod +x "$script"
        ./"$script"
        cd "$DOTFILES_DIR" || exit
    else
        echo "⚠️  Directory $dir not found, skipping."
    fi
}

# 1. Install Homebrew and Bundle first
# This script handles Homebrew installation and brew bundle
run_script "Homebrew" "install.sh"

# Ensure Homebrew is in the current shell session path for subsequent steps
if [[ -f "/opt/homebrew/bin/brew" ]]; then
    eval "$(/opt/homebrew/bin/brew shellenv)"
elif [[ -f "/usr/local/bin/brew" ]]; then
    eval "$(/usr/local/bin/brew shellenv)"
fi

# 2. Check and Install Node.js
echo ""
echo "------------------------------------------"
echo "🟢 Checking Node.js status..."
echo "------------------------------------------"
if ! command -v node &> /dev/null; then
    echo "Node.js not found."
    if command -v volta &> /dev/null; then
        echo "📦 Volta found. Installing Node.js via Volta..."
        volta install node
    else
        echo "🍺 Volta not found. Installing Node.js via Homebrew..."
        brew install node
    fi
else
    echo "✅ Node.js is already installed: $(node -v)"
fi

# 3. Run other installation scripts
run_script "macos" "install.sh"
run_script "Rectangle" "install.sh"
run_script "VSCode" "install.sh"

echo ""
echo "------------------------------------------"
echo "✨ All installations completed successfully!"
echo "------------------------------------------"
