#!/bin/bash

path_to_usb="/media/marcus/backup"

# List of paths to backup
paths=(
  # Directories
  "$HOME/Applications"
  "$HOME/.config"
  "$HOME/Documents"
  "$HOME/Downloads"
  "$HOME/.gitconfig"
  "$HOME/.gnupg"
  "$HOME/GNS3"
  "$HOME/.gtkrc-2.0"
  "$HOME/.kees"
  "$HOME/labs"
  "$HOME/.local/bin"
  "$HOME/.local/omgzilla"
  "$HOME/.local/share/history"
  "$HOME/.local/suckless"
  "$HOME/Pictures"
  "$HOME/.profile"
  "$HOME/snap"
  "$HOME/src"
  "$HOME/.ssh"
  "$HOME/versioned"
  "$HOME/.vscode"
  "$HOME/.wine"
)

# Check if rsync is installed
if command -v rsync &>/dev/null; then
  echo "rsync is installed, continuing..."
else
  echo "rsync is not installed, proceeding with installing rsync."
  sudo apt update && sudo apt install rsync
fi

# Backup all paths with rsync
for path in "${paths[@]}"; do
  rsync -a -v "$path" $path_to_usb/home_directory/
done
echo "All paths have been copied"

apt-mark showmanual > $path_to_usb/installed-apt-packages.txt
flatpak list > $path_to_usb/installed-flatpak-packages.txt
snap list > $path_to_usb/installed-snap-packages.txt


echo "Don't forget to manually copy NetworkManager"

echo "sudo cp -r /etc/NetworkManager $path_to_usb/NetworkManager && sudo chown -R marcus:marcus $path_to_usb/NetworkManager"

