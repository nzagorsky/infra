locals {
  vm_node_name = var.proxmox_node_name

  vm_agent_defaults = {
    enabled = true
    type    = "virtio"
    trim    = true
    timeout = "15m"
  }

  vm_cpu_defaults = {
    sockets = 1
    numa    = false
    type    = "host"
  }

  vm_disk_defaults = {
    interface    = "scsi0"
    datastore_id = "local-lvm"
    file_format  = "raw"
    discard      = "on"
    iothread     = true
    aio          = "io_uring"
    cache        = "none"
    backup       = true
    replicate    = true
    ssd          = true
  }

  vm_initialization_defaults = {
    datastore_id = "local-lvm"
    interface    = "ide2"
    ipv6_address = "dhcp"
    username     = var.vm_default_username
    keys         = ["ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIG/U9J4gbyz+Tu3MGcsgbSEA7I4T06+UA/66d7LD55uk nzagorsky"]
  }

  vm_memory_defaults = {
    floating = 0
    shared   = 0
  }

  vm_network_defaults = {
    bridge  = "vmbr0"
    model   = "virtio"
    enabled = true
  }

  vm_os_type    = "l26"
  vm_rng_source = "/dev/urandom"
  vm_vga = {
    type   = "qxl"
    memory = 16
  }
}
