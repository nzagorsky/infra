locals {
  firewall_vm_ids = toset([
    "130",
    "200",
    "202",
    "203",
    "204",
    "205",
    "210",
    "500",
    "9001",
  ])
}

resource "proxmox_virtual_environment_cluster_firewall" "cluster" {
  lifecycle {
    ignore_changes = all
  }
}

resource "proxmox_virtual_environment_cluster_firewall_security_group" "vm_isolate" {
  name = "vm-isolate"

  lifecycle {
    ignore_changes = all
  }
}

resource "proxmox_virtual_environment_firewall_options" "vms" {
  for_each = local.firewall_vm_ids

  node_name = var.proxmox_node_name
  vm_id     = tonumber(each.value)

  lifecycle {
    ignore_changes = all
  }
}

resource "proxmox_virtual_environment_firewall_rules" "vms" {
  for_each = local.firewall_vm_ids

  node_name = var.proxmox_node_name
  vm_id     = tonumber(each.value)

  lifecycle {
    ignore_changes = all
  }
}
