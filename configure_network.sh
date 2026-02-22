#!/bin/bash
# configure_network.sh - Configure iptables and routing for Cuckoo Sandbox

set -e

INTERFACE="eth0"
SUBNET="192.168.56.0/24"

echo "[+] Enabling IP forwarding..."
echo 1 | sudo tee /proc/sys/net/ipv4/ip_forward

echo "[+] Configuring iptables for NAT..."
# Clear existing rules (optional - be careful)
# sudo iptables -F
# sudo iptables -t nat -F

# Post-routing masquerade
sudo iptables -t nat -A POSTROUTING -o $INTERFACE -s $SUBNET -j MASQUERADE

# Forwarding rules
sudo iptables -A FORWARD -s $SUBNET -j ACCEPT
sudo iptables -A FORWARD -d $SUBNET -j ACCEPT

echo "[+] Saving iptables rules..."
# Make persistent (requires iptables-persistent package usually, but verifying availability first)
if dpkg -l | grep -q iptables-persistent; then
    sudo netfilter-persistent save
else
    echo "iptables-persistent not installed. Rules will be lost on reboot."
    echo "Install with: sudo apt install iptables-persistent"
fi

echo "[+] Network configuration complete."
