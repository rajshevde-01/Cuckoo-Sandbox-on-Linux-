# Cuckoo Sandbox - Windows Guest Setup Guide

This guide details how to prepare a Windows Virtual Machine for malware analysis with Cuckoo Sandbox.

## 1. Virtual Machine Creation
- **Hypervisor**: VirtualBox
- **Name**: `cuckoo-guest` (must match `cuckoo.conf` later)
- **OS**: Windows 7 (preferred) or Windows XP (classic)
- **RAM**: 1024 MB - 2048 MB
- **Network Adapter**: Host-only Adapter (`vboxnet0`)

### IMPORTANT: Host-Only Network
Ensure your VirtualBox Host-Only Network is configured:
- **IPv4 Address**: `192.168.56.1`
- **Mask**: `255.255.255.0`
- **DHCP Server**: Disabled (using static IP in guest)

## 2. Windows Guest Configuration
Install Windows on the VM. Once installed, perform the following:

### Networking
Set a static IP inside the Windows Guest:
- **IP Address**: `192.168.56.101`
- **Subnet Mask**: `255.255.255.0`
- **Gateway**: `192.168.56.1`
- **DNS**: `8.8.8.8` (or your preferred DNS)

### System Tweak
1. **Disable Windows Firewall**: Completely turn off firewall for all profiles.
2. **Disable Windows Updates**: Turn off automatic updates to prevent noise.
3. **Disable UAC**: User Account Control should be off (slider to bottom).
4. **Disable Windows Defender/Antivirus**: Ensure no interference with samples.

## 3. Python & Cuckoo Agent Pattern
1. **Install Python 2.7**: Download and install Python 2.7.x (x86 usually preferred) to `C:\Python27`.
    - **Note**: Cuckoo Agent `agent.py` is written for Python 2.7.
2. **Install Pillow (Optional)**: Needed for taking screenshots.
   ```cmd
   C:\Python27\python.exe -m pip install Pillow
   ```
3. **Copy Agent Script**:
   - Locate `agent.py` on your host machine (usually in `~/.cuckoo/agent/agent.py`).
   - Copy it to the Guest VM, place it at `C:\agent.py`.

### Startup Configuration
The agent must run automatically on startup.
- Open `regedit`
- Navigate to: `HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Run`
- Create a new **String Value**:
  - **Name**: `CuckooAgent`
  - **Value**: `"C:\Python27\python.exe" "C:\agent.py"`

## 4. Final Snapshot
1. Reboot the VM to test the Agent autostart.
2. Verify: A command prompt window running `agent.py` should appear (or run essentially headless depending on config). It should be listening on port 8000.
3. Test connectivity from Host:
   ```bash
   ping 192.168.56.101
   curl http://192.168.56.101:8000
   ```
4. **Take Snapshot**:
   - Save the running state of the VM (do not power off!).
   - Name: `clean-state` (This exact name is used in configuration).

Setup Complete. The guest is ready for analysis.
