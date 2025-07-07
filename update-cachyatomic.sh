#!/bin/bash

cd ~/Downloads/arkdep
git pull
# stay up to date with upstream
git fetch upstream
git merge upstream/main
git push origin main

sudo arkdep-build cachyatomic

# compare two most recent .pkgs files
./compare_pkgs.sh /home/hugh/Downloads/arkdep/target

# copy most recent .tar.zst file
#sudo cp /arkdep/target/"$(ls -t *.tar.zst | head -1)" /arkdep/cache/
./copy_cleanup_oneliner.sh

cd /arkdep/cache
sudo arkdep deploy cache "$(ls -t *.tar.zst | head -1)"

flatpak update
