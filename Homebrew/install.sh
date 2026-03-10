#!/bin/bash

echo "🚀 Starting your Mac configuration..."

if ! command -v brew &> /dev/null; then
    echo "🍺 Homebrew not found. Installing it now..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    
    echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> ~/.zprofile
    eval "$(/opt/homebrew/bin/brew shellenv)"
else
    echo "✅ Homebrew is already installed. Moving forward."
fi

echo "🔄 Updating Homebrew..."
brew update

if [ -f "Brewfile" ]; then
    echo "📦 Installing applications and tools from Brewfile..."
    brew bundle
    echo "✅ Installation completed successfully from Brewfile."
else
    echo "❌ Error: Brewfile not found in this directory!"
    exit 1
fi

echo "✨ Configuration complete! Your Mac is ready for work. Happy coding!"