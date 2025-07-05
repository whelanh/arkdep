!#/bin/bash

cd ~/Downloads
https://github.com/official-stockfish/Stockfish.git
cp ~/OneDrive/makeSF.sh .
chmod +x ./makeSF.sh
./makeSF.sh

sudo systemctl enable --now tailscaled
sudo tailscale up --ssh
