#!/bin/bash
# This is a comment
sudo dnf update && sudo apt upgrade -y
sudo dnf install -y git clang curl libssl-dev llvm libudev-dev
sudo curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
sudo source ~/.cargo/env
sudo rustup default stable
sudo rustup update
sudo rustup update nightly
sudo rustup target add wasm32-unknown-unknown --toolchain nightly
sudo wget https://get.gear.rs/gear-nightly-linux-x86_64.tar.xz
sudo tar -xvf gear-nightly-linux-x86_64.tar.xz -C /root
sudo rm gear-nightly-linux-x86_64.tar.xz
sudo cd /etc/systemd/system
echo "[Unit]
Description=Gear Node
After=network.target

[Service]
Type=simple
User=root
WorkingDirectory=/root/
ExecStart=/root/gear --name 'ИМЯ_НОДЫ' --telemetry-url 'ws://telemetry-backend-shard.gear-tech.io:32001/submit 0'
Restart=always
RestartSec=3
LimitNOFILE=10000

[Install]
WantedBy=multi-user.target" | sudo tee -a gear-node.service
sudo cd /root
sudo systemctl restart systemd-journald
sudo systemctl daemon-reload
sudo systemctl enable gear-node
sudo systemctl restart gear-node
sudo journalctl -n 100 -f -u gear-node
whoami