terraform {
    required_providers {
        proxmox = {
            source = "telmate/proxmox"
            version = "2.9.11"
        }
    }
}

provider "proxmox" {
    # url is the hostname 
    pm_api_url = "https://10.1.0.132:8006/api2/json"
    # api token id is in form of: <username>@pam!<tokenId>
    pm_api_token_id = "ed@pam!edvagevuur"
    pm_api_token_secret = "f77edc7b-e5ec-4bf1-a9e5-77ad3061c63f"
    pm_tls_insecure = true
}

resource "proxmox_qemu" "test_server" {
    count = 1
    name = "test-vm-${count.index + 1}"
    target_node = var.proxmox_host
    clone = var.template_name # Moet hier de juiste ISO staan???
    agent = 1
    os_type = "cloud-init"
    cores = 2
    sockets = 1
    cpu = "host"
    memory = "2048"
    scsihw = "virtio-scsi-pci"
    bootdisk = "scsi0" 
    disk {
        slot = 0
        size = "10G"
        type = "scsi"
        storage = "Potter"
        iothreat = 1
    }

    network {
        model = "virtio"
        bridge = "vmbr0"
    }

    lifecycle {
        ignore_changes = [
            network,
        ]
    }
}