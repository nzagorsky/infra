resource "proxmox_virtual_environment_vm" "vm_200_haos" {
  name      = "HAOS"
  node_name = var.proxmox_node_name
  vm_id     = 200

  description = null

  acpi                                 = true
  bios                                 = "ovmf"
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
    type    = "x86-64-v2-AES"
  }

  disk {
    interface    = "scsi0"
    datastore_id = "local-lvm"
    size         = 32
    file_format  = "raw"
    discard      = "on"
    iothread     = true
    aio          = "io_uring"
    cache        = "none"
    backup       = true
    replicate    = true
    ssd          = false
  }

  efi_disk {
    datastore_id      = "local-lvm"
    file_format       = "raw"
    pre_enrolled_keys = false
    type              = "4m"
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
