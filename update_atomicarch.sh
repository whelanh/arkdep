!#/bin/bash

cd ~/Downloads/arkdep
git pull

sudo arkdep-build atomicarch

# compare two most recent .pkgs files
./compare_pkgs.sh /home/$(whoami)/Downloads/arkdep/target

# copy most recent .tar.zst file
#sudo cp /arkdep/target/"$(ls -t *.tar.zst | head -1)" /arkdep/cache/
./copy_cleanup_oneliner.sh

cd /arkdep/cache
sudo arkdep deploy cache "$(ls -t *.tar.zst | head -1)"

flatpak update
