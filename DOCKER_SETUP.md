# Cuckoo Sandbox - Docker Setup Guide

This guide details how to run Cuckoo Sandbox (v3 Beta) in a Docker container.

## ⚠️ Important Note
This setup uses **Cuckoo 3** (Beta) because standard Cuckoo 2.x does not support Python 3. The Dockerfile compiles Cuckoo 3 from source.

## Prerequisites
1.  **Docker Desktop** installed on Windows or Docker Engine on Linux.
2.  **VirtualBox** installed on your host (tested with 6.1/7.0)

---

## 1. Prepare Host VirtualBox Service

### On Windows Host
The `vboxwebsrv` command is not in your PATH by default. You need to run it from the installation directory.

1.  **Open PowerShell as Administrator**.
2.  **Disable Auth** (for local testing):
    ```powershell
    & "C:\Program Files\Oracle\VirtualBox\VBoxManage.exe" setproperty websrvauthlibrary null
    ```
3.  **Start the Service**:
    ```powershell
    & "C:\Program Files\Oracle\VirtualBox\vboxwebsrv.exe" -H 0.0.0.0
    ```
    *Keep this terminal window open!*

### On Linux Host
```bash
VBoxManage setproperty websrvauthlibrary null
vboxwebsrv -b -H 0.0.0.0
```

---

## 2. Start Cuckoo Containers
Use Docker Compose to spin up Cuckoo, MongoDB, and Redis.

```bash
docker-compose up -d --build
```
This will:
- Build the `cuckoo` image (Python 3 based).
- Start `mongodb` and `redis`.

## 3. Configure Cuckoo for VirtualBox
Once the container is running, you need to configure it to talk to your host's VirtualBox.

1.  **Initialize Configuration**:
    Perform the following one-time setup:

    a. **Create Marker File**:
       Run this on your host (PowerShell) to satisfy Cuckoo's validation:
       ```powershell
       mkdir cuckoo_data -ErrorAction SilentlyContinue
       echo . > cuckoo_data\.cuckoocwd
       ```

    b. **Populate Directories**:
       ```bash
       docker-compose run --rm cuckoo cuckoo createcwd --update-directories
       ```

    c. **Initialize Database**:
       ```bash
       docker-compose run --rm cuckoo cuckoomigrate database all
       ```
    
    Config files will appear in `cuckoo_data/conf/` on your host.
    
2.  **Configure Virtualization**:
    > **⚠️ IMPORTANT**: The current Cuckoo 3 Beta (v3.0) release from `cert-ee` includes explicit support for **QEMU, KVM, and Proxmox** by default. Use of VirtualBox may require a community plugin or custom machinery module which is not included in the base installation.
    
    If you intend to use VirtualBox, you may need to find a compatible `virtualbox.py` module for Cuckoo 3 or switch to using **QEMU** (which is configured by default in `cuckoo.yaml` and `machineries/qemu.yaml`).
    
    To enable a machinery, edit `cuckoo_data/conf/cuckoo.yaml`:
    ```yaml
    machineries:
      - qemu
    ```
    
    And configure the corresponding file in `cuckoo_data/conf/machineries/qemu.yaml`.
    
    To talk to your Windows Host `vboxwebsrv`:
    - Use `host.docker.internal` instead of `localhost` or `127.0.0.1`.
    
    ```ini
    [virtualbox]
    # url = http://host.docker.internal:18083
    ```

## 4. Accessing Cuckoo
Web Interface: http://localhost:8000
