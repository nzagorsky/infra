resource "proxmox_virtual_environment_storage_directory" "local" {
  id      = "local"
  path    = "/var/lib/vz"
  content = ["backup", "iso", "vztmpl"]
  disable = false
  nodes   = []
  shared  = false
}

resource "proxmox_virtual_environment_storage_lvmthin" "local_lvm" {
  id           = "local-lvm"
  thin_pool    = "data"
  volume_group = "pve"
  content      = ["images", "rootdir"]
  disable      = false
  nodes        = []
}

resource "proxmox_virtual_environment_network_linux_bridge" "vmbr0" {
  name       = "vmbr0"
  node_name  = var.proxmox_node_name
  address    = local.vmbr0_address
  autostart  = true
  gateway    = var.vm_default_ipv4_gateway
  ports      = ["enp2s0"]
  vlan_aware = false
}

resource "proxmox_virtual_environment_cluster_options" "cluster" {
  keyboard   = "en-us"
  mac_prefix = "BC:24:11"

  lifecycle {
    ignore_changes = [
      mac_prefix,
    ]
  }
}

resource "proxmox_virtual_environment_dns" "proxmox" {
  node_name = var.proxmox_node_name
  domain    = var.proxmox_dns_domain
  servers   = ["1.1.1.1", "8.8.8.8"]
}

resource "proxmox_virtual_environment_time" "proxmox" {
  node_name = var.proxmox_node_name
  time_zone = var.proxmox_time_zone
}
