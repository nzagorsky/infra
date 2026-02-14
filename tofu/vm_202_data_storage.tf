resource "proxmox_virtual_environment_vm" "vm_202_data_storage" {
  name      = "data-storage"
  node_name = var.proxmox_node_name
  vm_id     = 202

  description = <<-EOT
    NFS export: <nfs-server>:/srv/nfs/k8s

    # Path
    ```
    nfs.internal.example.invalid
    ```

    ### Test oneliner
    ```bash
    sudo apt-get update -y && sudo apt-get install -y --no-install-recommends nfs-common && sudo mkdir -p /mnt/k8s-nfs && sudo mount -t nfs -o vers=4.1,proto=tcp <nfs-server>:/srv/nfs/k8s /mnt/k8s-nfs && echo "ok" | sudo tee /mnt/k8s-nfs/_nfs_test_$(hostname -s)_$(date -u +%Y%m%dT%H%M%SZ).txt >/dev/null && ls -lah /mnt/k8s-nfs | tail

    ```
  EOT

  acpi                                 = true
  bios                                 = "seabios"
  boot_order                           = ["scsi0"]
  delete_unreferenced_disks_on_destroy = true
  machine                              = "q35"
  migrate                              = false
  on_boot                              = true
  protection                           = false
  purge_on_destroy                     = true
  reboot                               = false
  reboot_after_update                  = true
  keyboard_layout                      = null
  scsi_hardware                        = "virtio-scsi-single"
  started                              = true
  stop_on_destroy                      = false
  tablet_device                        = true
  tags                                 = []
  template                             = false

  agent {
    enabled = true
    type    = null
    trim    = true
    timeout = "15m"
  }

  cpu {
    cores   = 2
    sockets = 1
    numa    = false
    type    = "host"
  }

  disk {
    interface    = "scsi0"
    datastore_id = "local-lvm"
    size         = 53
    file_format  = "raw"
    discard      = "on"
    iothread     = true
    aio          = "io_uring"
    cache        = "none"
    backup       = true
    replicate    = true
    ssd          = true
  }

  initialization {
    datastore_id = "local-lvm"
    interface    = "ide2"

    ip_config {
      ipv4 {
        address = var.vm_data_storage_ipv4_address
        gateway = var.vm_default_ipv4_gateway
      }
      ipv6 {
        address = "dhcp"
      }
    }

    user_account {
      username = var.vm_default_username
      keys     = var.vm_default_ssh_keys
    }
  }

  memory {
    dedicated = 4096
    floating  = 0
    shared    = 0
  }

  network_device {
    bridge      = "vmbr0"
    model       = "virtio"
    mac_address = var.vm_data_storage_mac_address
    firewall    = false
    enabled     = true
  }

  operating_system {
    type = "l26"
  }

  rng {
    source = "/dev/urandom"
  }

  vga {
    type   = "qxl"
    memory = 16
  }

  lifecycle {
    prevent_destroy = true
    ignore_changes = [
      description,
      initialization,
      initialization[0].ip_config,
      keyboard_layout,
      agent[0].type,
      initialization[0].user_account[0].password,
      network_device[0].mac_address,
    ]
  }
}
