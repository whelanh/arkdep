#!/bin/bash

cd Downloads
git clone --recurse-submodules https://github.com/whelanh/arkdep.git
cd arkdep
sudo arkdep-build cachyatomic

sudo cp target/cachyatomic-202*.tar.zst /arkdep/cache/

cd /arkdep/cache
sudo arkdep deploy cache cachyatomic-202*.tar.zst
