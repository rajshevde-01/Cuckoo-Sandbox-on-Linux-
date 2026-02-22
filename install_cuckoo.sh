#!/bin/bash
# install_cuckoo.sh - Install Cuckoo Sandbox and setup user

set -e

echo "[+] Creating Cuckoo user and group..."
sudo adduser --disabled-password --gecos "" cuckoo
sudo usermod -aG vboxusers cuckoo

echo "[+] Installing Cuckoo via pip..."
# Switching to cuckoo user context for installation
sudo -u cuckoo pip3 install --user cuckoo

echo "[+] Initializing Cuckoo configuration..."
sudo -u cuckoo /home/cuckoo/.local/bin/cuckoo init

echo "[+] Downloading community signatures..."
sudo -u cuckoo /home/cuckoo/.local/bin/cuckoo community

echo "[+] Cuckoo installation complete. Check /home/cuckoo/.cuckoo for configuration."
