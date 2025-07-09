#!/bin/bash

# Check if argument is provided
if [ $# -eq 0 ]; then
    echo "Usage: $0 <architecture>"
    echo "Example: $0 atomicarch"
    exit 1
fi

# Get the architecture argument
ARCH="$1"

echo "Checking on updates to see if worth doing...."
checkupdates
yay -Qua

read -p "Do you want to proceed with the updates? (y/N): " answer

if [[ "$answer" =~ ^[Nn]$ || -z "$answer" ]]; then
    echo "Update canceled."
    exit 0
fi


git pull
sudo arkdep-build "$ARCH"
# compare two most recent .pkgs files
./compare_pkgs.sh ./target
# copy most recent .tar.zst file
#sudo cp /arkdep/target/"$(ls -t *.tar.zst | head -1)" /arkdep/cache/
./copy_cleanup_oneliner.sh
cd /arkdep/cache
sudo arkdep deploy cache "$(ls -t *.tar.zst | head -1)"
flatpak update
brew update && brew upgrade
