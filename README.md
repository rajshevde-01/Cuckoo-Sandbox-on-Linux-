# Cuckoo Sandbox Setup Automation (Project 2)

Automated scripts and documentation for setting up Cuckoo Sandbox on Ubuntu 22.04.

## Overview
Cuckoo is an open-source automated malware analysis system. This project provides:
1.  **Host Setup**: Automated dependency installation.
2.  **Cuckoo Installation**: Dedicated user creation and pip installation.
3.  **Network Configuration**: iptables rules for Guest VM connectivity.
4.  **Guest Setup Guide**: Detailed manual steps for Windows Guest VM.

## Architecture
```
[You] ──submits file──▶ [Cuckoo Host - Ubuntu]
                              │
                         monitors via
                              │
                        [VirtualBox VM]
                        Windows Guest
                        + Cuckoo Agent
                              │
                         behavior logs
                              ▼
                        [Cuckoo Reports]
                        JSON / HTML / MISP
```

## Quick Start on Ubuntu 22.04 Host

### 1. Setup Host Dependencies
Run the host setup script to install system packages and configure capabilities.
```bash
chmod +x setup_host.sh
./setup_host.sh
```

### 2. Install Cuckoo
Run the installation script to create the `cuckoo` user and install the Cuckoo package.
```bash
chmod +x install_cuckoo.sh
./install_cuckoo.sh
```

### 3. Configure Network
Set up NAT and forwarding for the Guest VM network (default `192.168.56.0/24`).
```bash
chmod +x configure_network.sh
./configure_network.sh
```

### 4. Setup Guest VM
Follow the detailed steps in [GUEST_SETUP.md](GUEST_SETUP.md) to create and configure your Windows VM.

### 5. Docker Setup (Recommended: Linux)

#### A. Start Containers
```bash
docker-compose up -d
```

#### B. One-Time Initialization
Run these commands to prepare the environment:
```bash
# 1. Create marker file
mkdir -p cuckoo_data
touch cuckoo_data/.cuckoocwd

# 2. Populate directories & database
docker-compose run --rm cuckoo cuckoo createcwd --update-directories
docker-compose run --rm cuckoo cuckoomigrate database all
```

#### C. Start Web Interface
```bash
docker-compose run -p 8000:8000 --rm cuckoo cuckoo web -h 0.0.0.0 -p 8000
```
Access at [http://localhost:8000](http://localhost:8000).

---

### 6. Docker Setup on Windows (Optional)
If you are testing on Windows, use these PowerShell equivalents:

**1. Create Marker File (PowerShell)**:
```powershell
mkdir cuckoo_data -ErrorAction SilentlyContinue
echo . > cuckoo_data\.cuckoocwd
```

**2. Populate & Start**:
```powershell
# Initialize
docker-compose run --rm cuckoo cuckoo createcwd --update-directories
docker-compose run --rm cuckoo cuckoomigrate database all

# Start Web Interface
docker-compose run -p 8000:8000 --rm cuckoo cuckoo web -h 0.0.0.0 -p 8000
```
> **Note**: Always access at `localhost` on Windows, not `0.0.0.0`.

For detailed VirtualBox/QEMU configuration, see [DOCKER_SETUP.md](DOCKER_SETUP.md).

## Usage
Once setup is complete:

1.  **Start Cuckoo**:
    ```bash
    # Switch to cuckoo user
    su - cuckoo
    cuckoo
    ```

2.  **Submit Analysis**:
    ```bash
    cuckoo submit /path/to/malware.exe
    ```

3.  **Web Interface**:
    ```bash
    cuckoo web runserver
    # Access at http://localhost:8000
    ```

## Author
Raj Shevde

## License
MIT
