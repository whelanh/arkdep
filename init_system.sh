#!/bin/bash

# Check if argument is provided
if [ $# -eq 0 ]; then
    echo "Usage: $0 <architecture>"
    echo "Example: $0 atomicarch"
    exit 1
fi

# Get the architecture argument
ARCH="$1"

cd Downloads
git clone --recurse-submodules https://github.com/whelanh/arkdep.git
cd arkdep
sudo arkdep-build "$ARCH"

./copy_cleanup_oneliner.sh

cd /arkdep/cache
sudo arkdep deploy cache "$(ls -t *.tar.zst | head -1)"
