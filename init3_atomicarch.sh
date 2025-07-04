!#/bin/bash

# Do this after you have installed onedrive in the archcontainer and exported it
echo 'export PATH="$HOME/.local/bin:$PATH"' >> ~/.zshrc
echo 'export PATH="$HOME/.local/bin:$PATH"' >> ~/.bashrc

cp /usr/lib/systemd/user/onedrive.service ~/onedrive.service
# Copy to your user systemd directory
mkdir -p ~/.config/systemd/user
cp ~/distrobox-arch/onedrive.service ~/.config/systemd/user

# Edit the service file to use the exported binary path
micro ~/.config/systemd/user/onedrive.service
# ExecStart=/home/hugh/.local/bin/onedrive --monitor

systemctl --user daemon-reload
systemctl --user enable onedrive
systemctl --user start onedrive

cd ~/Downloads
https://github.com/official-stockfish/Stockfish.git
cp ~/distrobox-arch/OneDrive/makeSF.sh .
chmod +x ./makeSF.sh
./makeSF.sh
