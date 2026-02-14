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
  enabled = true

  lifecycle {
    ignore_changes = [
      input_policy,
      output_policy,
      forward_policy,
    ]
  }
}

resource "proxmox_virtual_environment_cluster_firewall_security_group" "vm_isolate" {
  name    = "vm-isolate"
  comment = "Disable LAN Access"

  rule {
    action  = "ACCEPT"
    comment = "Allow All IN"
    enabled = true
    log     = "nolog"
    type    = "in"
  }

  rule {
    action  = "REJECT"
    comment = "Block LAN"
    dest    = local.lan_cidr
    enabled = true
    log     = "nolog"
    type    = "out"
  }
}

resource "proxmox_virtual_environment_firewall_options" "vms" {
  for_each = local.firewall_vm_ids

  node_name = var.proxmox_node_name
  vm_id     = tonumber(each.value)

  lifecycle {
    ignore_changes = [
      dhcp,
      enabled,
      input_policy,
      log_level_in,
      log_level_out,
      macfilter,
      ndp,
      output_policy,
      radv,
    ]
  }
}

resource "proxmox_virtual_environment_firewall_rules" "vms" {
  for_each = local.firewall_vm_ids

  node_name = var.proxmox_node_name
  vm_id     = tonumber(each.value)

  dynamic "rule" {
    for_each = contains(["210", "9001"], each.value) ? [1] : []
    content {
      enabled        = true
      security_group = "vm-isolate"
    }
  }
}
