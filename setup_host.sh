#!/bin/bash
# setup_host.sh - Install system dependencies for Cuckoo Sandbox on Ubuntu 22.04

set -e

echo "[+] Updating apt repositories..."
sudo apt update

echo "[+] Installing system dependencies..."
sudo apt install -y \
    python3 python3-pip python3-dev \
    virtualbox virtualbox-dkms \
    tcpdump libcap2-bin \
    mongodb redis-server \
    ssdeep libfuzzy-dev \
    git curl wget

echo "[+] Configuring tcpdump permissions..."
sudo setcap cap_net_raw,cap_net_admin=eip /usr/bin/tcpdump

echo "[+] Verifying tcpdump capabilities..."
getcap /usr/bin/tcpdump

echo "[+] Host setup complete."
