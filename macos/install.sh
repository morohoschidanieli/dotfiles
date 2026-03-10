#!/bin/zsh

# macOS System Defaults Setup Script

# Ensure common paths are in PATH
export PATH="/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin:/opt/homebrew/bin:$PATH"

# Determine if we should use "System Settings" (Ventura and later) or "System Preferences"
if [[ $(sw_vers -productVersion | cut -d . -f 1) -ge 13 ]]; then
    SYSTEM_APP="System Settings"
else
    SYSTEM_APP="System Preferences"
fi

# Close any open System Settings/Preferences panes to prevent them from overriding settings
if pgrep -x "$SYSTEM_APP" > /dev/null; then
    osascript -e "tell application \"$SYSTEM_APP\" to quit"
fi

echo "⚙️  Setting up macOS system defaults (cloned from current setup)..."

###############################################################################
# General UI/UX                                                               #
###############################################################################

echo "🎨 Setting Dark Mode..."
# Set Dark Mode
osascript -e 'tell application "System Events" to tell appearance preferences to set dark mode to true'

###############################################################################
# Dock                                                                        #
###############################################################################

echo "🍎 Configuring Dock..."

# Set the icon size of Dock items
defaults write com.apple.dock tilesize -int 34

# Position the dock
defaults write com.apple.dock orientation -string "left"

# Change minimize/maximize window effect
defaults write com.apple.dock mineffect -string "genie"

# Don't automatically hide and show the Dock
defaults write com.apple.dock autohide -bool false

# Minimize windows into their application’s icon
defaults write com.apple.dock minimize-to-application -bool true

# Show indicator lights for open applications in the Dock
defaults write com.apple.dock show-process-indicators -bool true

# Don’t show recent applications in Dock
defaults write com.apple.dock show-recents -bool false

###############################################################################
# Finder                                                                      #
###############################################################################

echo "📂 Configuring Finder..."

# Finder: show status bar
defaults write com.apple.finder ShowStatusBar -bool true

# Finder: show path bar
defaults write com.apple.finder ShowPathbar -bool true

# Keep folders on top when sorting by name
defaults write com.apple.finder _FXSortFoldersFirst -bool true

# When performing a search, search the current folder by default
defaults write com.apple.finder FXDefaultSearchScope -string "SCcf"

# Disable the warning when changing a file extension
defaults write com.apple.finder FXEnableExtensionChangeWarning -bool false

# Avoid creating .DS_Store files on network or USB volumes
defaults write com.apple.desktopservices DSDontWriteNetworkStores -bool true
defaults write com.apple.desktopservices DSDontWriteUSBStores -bool true

# Use list view in all Finder windows by default
defaults write com.apple.finder FXPreferredViewStyle -string "Nlsv"

###############################################################################
# Keyboard & Trackpad                                                         #
###############################################################################

echo "⌨️  Configuring Keyboard & Trackpad..."

# Trackpad: tap to click
defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad Clicking -bool false
defaults -currentHost write NSGlobalDomain com.apple.mouse.tapBehavior -int 0
defaults write NSGlobalDomain com.apple.mouse.tapBehavior -int 0

# Disable auto-correct
defaults write NSGlobalDomain NSAutomaticSpellingCorrectionEnabled -bool false

###############################################################################
# Kill affected applications                                                  #
###############################################################################

echo "🔄 Restarting apps to apply changes..."

for app in "Dock" \
	"Finder" \
	"SystemUIServer"; do
	killall "${app}" &> /dev/null
done

echo "✨ macOS setup complete! Your settings have been cloned to this script."
