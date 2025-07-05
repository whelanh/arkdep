#!/bin/bash

cd Downloads
git clone --recurse-submodules https://github.com/whelanh/arkdep.git
cd arkdep
sudo arkdep-build atomicarch

sudo cp target/atomicarch-202*.tar.zst /arkdep/cache/

cd /arkdep/cache
sudo arkdep deploy cache atomicarch-202*.tar.zst
