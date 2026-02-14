resource "proxmox_virtual_environment_vm" "haos" {
  name      = "HAOS"
  node_name = var.proxmox_node_name
  vm_id     = 200

  lifecycle {
    prevent_destroy = true
    ignore_changes  = all
  }
}

resource "proxmox_virtual_environment_vm" "azerothcore" {
  name      = "azerothcore"
  node_name = var.proxmox_node_name
  vm_id     = 130

  lifecycle {
    prevent_destroy = true
    ignore_changes  = all
  }
}

resource "proxmox_virtual_environment_vm" "k3s_dev" {
  name      = "k3s-dev"
  node_name = var.proxmox_node_name
  vm_id     = 205

  lifecycle {
    prevent_destroy = true
    ignore_changes  = all
  }
}

resource "proxmox_virtual_environment_vm2" "tailscale" {
  name      = "tailscale"
  node_name = var.proxmox_node_name

  lifecycle {
    prevent_destroy = true
    ignore_changes  = all
  }
}

resource "proxmox_virtual_environment_vm" "ubuntu_24_04_cloud_template" {
  name      = "ubuntu-24-04-cloud"
  node_name = var.proxmox_node_name
  vm_id     = 9001

  lifecycle {
    prevent_destroy = true
    ignore_changes  = all
  }
}
