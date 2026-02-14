resource "proxmox_virtual_environment_vm" "vm_9001_ubuntu_24_04_cloud_template" {
  name      = "ubuntu-24-04-cloud"
  node_name = var.proxmox_node_name
  vm_id     = 9001

  description = null

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
  started                              = false
  stop_on_destroy                      = false
  tablet_device                        = true
  tags                                 = []
  template                             = true

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
    size         = 13
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

    dns {
      servers = ["1.1.1.1"]
    }

    ip_config {
      ipv4 {
        address = "dhcp"
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
    bridge   = "vmbr0"
    model    = "virtio"
    firewall = true
    enabled  = true
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
