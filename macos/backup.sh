#!/bin/zsh

# macOS System Defaults Backup Script
# This script reads current macOS settings and updates macos/install.sh

# Ensure common paths are in PATH
export PATH="/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin:/opt/homebrew/bin:$PATH"

# Get the directory where the script is located
SCRIPT_DIR="${0:A:h}"
INSTALL_SCRIPT="$SCRIPT_DIR/install.sh"

echo "⚙️  Backing up macOS system defaults to $INSTALL_SCRIPT..."

# Helper function to get a boolean value as 'true' or 'false'
get_bool() {
    local domain=$1
    local key=$2
    local val=$(defaults read "$domain" "$key" 2>/dev/null)
    if [[ "$val" == "1" ]]; then
        echo "true"
    else
        echo "false"
    fi
}

# Helper function to get an integer value
get_int() {
    local domain=$1
    local key=$2
    defaults read "$domain" "$key" 2>/dev/null
}

# Helper function to get a string value
get_str() {
    local domain=$1
    local key=$2
    defaults read "$domain" "$key" 2>/dev/null
}

# Read current values
DOCK_TILESIZE=$(get_int com.apple.dock tilesize)
DOCK_ORIENTATION=$(get_str com.apple.dock orientation)
DOCK_EFFECT=$(get_str com.apple.dock mineffect)
DOCK_AUTOHIDE=$(get_bool com.apple.dock autohide)
DOCK_MIN_TO_APP=$(get_bool com.apple.dock minimize-to-application)
DOCK_INDICATORS=$(get_bool com.apple.dock show-process-indicators)
DOCK_RECENTS=$(get_bool com.apple.dock show-recents)

FINDER_STATUSBAR=$(get_bool com.apple.finder ShowStatusBar)
FINDER_PATHBAR=$(get_bool com.apple.finder ShowPathbar)
FINDER_SORT_FOLDERS=$(get_bool com.apple.finder _FXSortFoldersFirst)
FINDER_SEARCH_SCOPE=$(get_str com.apple.finder FXDefaultSearchScope)
FINDER_EXT_WARNING=$(get_bool com.apple.finder FXEnableExtensionChangeWarning)
FINDER_VIEW_STYLE=$(get_str com.apple.finder FXPreferredViewStyle)

# Update the install.sh file with current values
# We'll use a template approach or just direct replacement for specific lines if we want to be surgical,
# but for simplicity and since we want to "clone" the setup, we can recreate the content.

cat <<EOF > "$INSTALL_SCRIPT"
#!/bin/zsh

# macOS System Defaults Setup Script

# Ensure common paths are in PATH
export PATH="/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin:/opt/homebrew/bin:\$PATH"

# Determine if we should use "System Settings" (Ventura and later) or "System Preferences"
if [[ \$(sw_vers -productVersion | cut -d . -f 1) -ge 13 ]]; then
    SYSTEM_APP="System Settings"
else
    SYSTEM_APP="System Preferences"
fi

# Close any open System Settings/Preferences panes to prevent them from overriding settings
if pgrep -x "\$SYSTEM_APP" > /dev/null; then
    osascript -e "tell application \"\$SYSTEM_APP\" to quit"
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
defaults write com.apple.dock tilesize -int ${DOCK_TILESIZE:-34}

# Position the dock
defaults write com.apple.dock orientation -string "${DOCK_ORIENTATION:-left}"

# Change minimize/maximize window effect
defaults write com.apple.dock mineffect -string "${DOCK_EFFECT:-genie}"

# Don't automatically hide and show the Dock
defaults write com.apple.dock autohide -bool ${DOCK_AUTOHIDE:-false}

# Minimize windows into their application’s icon
defaults write com.apple.dock minimize-to-application -bool ${DOCK_MIN_TO_APP:-true}

# Show indicator lights for open applications in the Dock
defaults write com.apple.dock show-process-indicators -bool ${DOCK_INDICATORS:-true}

# Don’t show recent applications in Dock
defaults write com.apple.dock show-recents -bool ${DOCK_RECENTS:-false}

###############################################################################
# Finder                                                                      #
###############################################################################

echo "📂 Configuring Finder..."

# Finder: show status bar
defaults write com.apple.finder ShowStatusBar -bool ${FINDER_STATUSBAR:-true}

# Finder: show path bar
defaults write com.apple.finder ShowPathbar -bool ${FINDER_PATHBAR:-true}

# Keep folders on top when sorting by name
defaults write com.apple.finder _FXSortFoldersFirst -bool ${FINDER_SORT_FOLDERS:-true}

# When performing a search, search the current folder by default
defaults write com.apple.finder FXDefaultSearchScope -string "${FINDER_SEARCH_SCOPE:-SCcf}"

# Disable the warning when changing a file extension
defaults write com.apple.finder FXEnableExtensionChangeWarning -bool ${FINDER_EXT_WARNING:-false}

# Avoid creating .DS_Store files on network or USB volumes
defaults write com.apple.desktopservices DSDontWriteNetworkStores -bool true
defaults write com.apple.desktopservices DSDontWriteUSBStores -bool true

# Use list view in all Finder windows by default
defaults write com.apple.finder FXPreferredViewStyle -string "${FINDER_VIEW_STYLE:-Nlsv}"

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

for app in "Dock" \\
	"Finder" \\
	"SystemUIServer"; do
	killall "\${app}" &> /dev/null
done

echo "✨ macOS setup complete! Your settings have been cloned to this script."
EOF

chmod +x "$INSTALL_SCRIPT"
echo "✅ $INSTALL_SCRIPT has been updated with your current settings."
