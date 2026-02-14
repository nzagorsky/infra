locals {
  vm_node_name = var.proxmox_node_name
  lan_cidr     = cidrsubnet(var.vm_data_storage_ipv4_address, 0, 0)
  lan_prefix   = split("/", local.lan_cidr)[1]
  vm_data_db_ipv4_address = coalesce(
    var.vm_data_db_ipv4_address,
    format("%s/%s", cidrhost(local.lan_cidr, 203), local.lan_prefix),
  )
  vm_games_minecraft_ipv4_address = coalesce(
    var.vm_games_minecraft_ipv4_address,
    format("%s/%s", cidrhost(local.lan_cidr, 210), local.lan_prefix),
  )
  vm_k3s_prod_ipv4_address = coalesce(
    var.vm_k3s_prod_ipv4_address,
    cidrhost(local.lan_cidr, 204),
  )
  vmbr0_address = format(
    "%s/24",
    cidrhost(local.lan_cidr, 20),
  )

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
