resource "proxmox_virtual_environment_storage_directory" "local" {
  id   = "local"
  path = "/var/lib/vz"

  lifecycle {
    ignore_changes = all
  }
}

resource "proxmox_virtual_environment_storage_lvmthin" "local_lvm" {
  id           = "local-lvm"
  thin_pool    = "data"
  volume_group = "pve"

  lifecycle {
    ignore_changes = all
  }
}

resource "proxmox_virtual_environment_network_linux_bridge" "vmbr0" {
  name      = "vmbr0"
  node_name = var.proxmox_node_name

  lifecycle {
    ignore_changes = all
  }
}

resource "proxmox_virtual_environment_cluster_options" "cluster" {
  lifecycle {
    ignore_changes = all
  }
}

resource "proxmox_virtual_environment_dns" "proxmox" {
  node_name = var.proxmox_node_name
  domain    = var.proxmox_dns_domain

  lifecycle {
    ignore_changes = all
  }
}

resource "proxmox_virtual_environment_time" "proxmox" {
  node_name = var.proxmox_node_name
  time_zone = var.proxmox_time_zone

  lifecycle {
    ignore_changes = all
  }
}
