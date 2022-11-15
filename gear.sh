#!/bin/bash
sudo dnf update && sudo apt upgrade -y
sudo dnf install -y git clang curl libssl-dev llvm libudev-dev
sudo curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
cd /root
source /root/.cargo/env
rustup default stable
rustup update
rustup update nightly
rustup target add wasm32-unknown-unknown --toolchain nightly
sudo wget https://get.gear.rs/gear-nightly-linux-x86_64.tar.xz
sudo tar -xvf gear-nightly-linux-x86_64.tar.xz -C /root
sudo chmod +x /root/gear
sudo rm gear-nightly-linux-x86_64.tar.xz
sudo tee /etc/systemd/system/gear-node.service > /dev/null << EOF
[Unit]
Description=Gear Node
After=network.target
[Service]
Type=simple
User=root
WorkingDirectory=/root/
ExecStart=/root/gear --name 'ArtenNode' --telemetry-url 'ws://telemetry-backend-shard.gear-tech.io:32001/submit 0'
Restart=always
RestartSec=3
LimitNOFILE=10000
[Install]
WantedBy=multi-user.target
EOF
sudo systemctl restart systemd-journald
sudo systemctl daemon-reload
sudo systemctl enable gear-node.service
sudo systemctl restart gear-node.service
sudo journalctl -n 100 -f -u gear-node