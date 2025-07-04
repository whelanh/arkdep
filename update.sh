!#/bin/bash

cd ~/Downloads/arkdep
git pull
git fetch upstream
git merge upstream/main
git push origin main
rm /target/*
sudo arkdep-build atomicarch

sudo cp target/atomicarch-202*.tar.zst /arkdep/cache/

cd /arkdep/cache
sudo arkdep deploy cache atomicarch

flatpak update
