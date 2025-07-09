#!/bin/bash

# Check if argument is provided
if [ $# -eq 0 ]; then
    echo "Usage: $0 <architecture>"
    echo "Example: $0 atomicarch"
    exit 1
fi

# Get the architecture argument
ARCH="$1"

sudo arkdep-build "$ARCH"

cd /arkdep/cache
sudo arkdep deploy cache "$(ls -t *.tar.zst | head -1)"
