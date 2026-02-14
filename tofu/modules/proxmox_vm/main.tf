resource "proxmox_virtual_environment_vm" "this" {
  name                                 = var.name
  node_name                            = var.node_name
  vm_id                                = var.vm_id
  description                          = var.description
  acpi                                 = var.acpi
  bios                                 = var.bios
  boot_order                           = var.boot_order
  delete_unreferenced_disks_on_destroy = var.delete_unreferenced_disks_on_destroy
  machine                              = var.machine
  migrate                              = var.migrate
  on_boot                              = var.on_boot
  protection                           = var.protection
  purge_on_destroy                     = var.purge_on_destroy
  reboot                               = var.reboot
  reboot_after_update                  = var.reboot_after_update
  keyboard_layout                      = var.keyboard_layout
  scsi_hardware                        = var.scsi_hardware
  started                              = var.started
  stop_on_destroy                      = var.stop_on_destroy
  tablet_device                        = var.tablet_device
  tags                                 = var.tags
  template                             = var.template

  agent {
    enabled = var.agent.enabled
    type    = try(var.agent.type, null)
    trim    = var.agent.trim
    timeout = var.agent.timeout
  }

  cpu {
    cores   = var.cpu.cores
    sockets = var.cpu.sockets
    numa    = var.cpu.numa
    type    = var.cpu.type
  }

  disk {
    interface    = var.disk.interface
    datastore_id = var.disk.datastore_id
    size         = var.disk.size
    file_format  = var.disk.file_format
    discard      = var.disk.discard
    iothread     = var.disk.iothread
    aio          = var.disk.aio
    cache        = var.disk.cache
    backup       = var.disk.backup
    replicate    = var.disk.replicate
    ssd          = var.disk.ssd
  }

  dynamic "efi_disk" {
    for_each = var.efi_disk == null ? [] : [var.efi_disk]
    content {
      datastore_id      = efi_disk.value.datastore_id
      file_format       = efi_disk.value.file_format
      pre_enrolled_keys = efi_disk.value.pre_enrolled_keys
      type              = efi_disk.value.type
    }
  }

  dynamic "initialization" {
    for_each = var.initialization == null ? [] : [var.initialization]
    content {
      datastore_id = initialization.value.datastore_id
      interface    = initialization.value.interface

      dynamic "dns" {
        for_each = length(try(initialization.value.dns_servers, [])) > 0 ? [1] : []
        content {
          servers = initialization.value.dns_servers
        }
      }

      ip_config {
        ipv4 {
          address = initialization.value.ipv4_address
          gateway = try(initialization.value.ipv4_gateway, null)
        }
        ipv6 {
          address = initialization.value.ipv6_address
        }
      }

      user_account {
        username = initialization.value.username
        keys     = initialization.value.keys
      }
    }
  }

  memory {
    dedicated = var.memory.dedicated
    floating  = var.memory.floating
    shared    = var.memory.shared
  }

  network_device {
    bridge      = var.network_device.bridge
    model       = var.network_device.model
    mac_address = try(var.network_device.mac_address, null)
    firewall    = var.network_device.firewall
    enabled     = var.network_device.enabled
  }

  operating_system {
    type = var.operating_system_type
  }

  dynamic "rng" {
    for_each = var.rng_source == null ? [] : [var.rng_source]
    content {
      source = rng.value
    }
  }

  dynamic "vga" {
    for_each = var.vga == null ? [] : [var.vga]
    content {
      type   = vga.value.type
      memory = try(vga.value.memory, null)
    }
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
