module "vms" {
  source   = "../../modules/proxmox_vm"
  for_each = local.vm_specs

  name                                 = each.value.name
  node_name                            = local.vm_node_name
  vm_id                                = each.value.vm_id
  description                          = each.value.description
  acpi                                 = each.value.acpi
  bios                                 = each.value.bios
  boot_order                           = each.value.boot_order
  delete_unreferenced_disks_on_destroy = each.value.delete_unreferenced_disks_on_destroy
  machine                              = each.value.machine
  migrate                              = each.value.migrate
  on_boot                              = each.value.on_boot
  protection                           = each.value.protection
  purge_on_destroy                     = each.value.purge_on_destroy
  reboot                               = each.value.reboot
  reboot_after_update                  = each.value.reboot_after_update
  keyboard_layout                      = each.value.keyboard_layout
  scsi_hardware                        = each.value.scsi_hardware
  started                              = each.value.started
  stop_on_destroy                      = each.value.stop_on_destroy
  tablet_device                        = each.value.tablet_device
  tags                                 = each.value.tags
  template                             = each.value.template

  agent                 = each.value.agent
  cpu                   = each.value.cpu
  disk                  = each.value.disk
  efi_disk              = each.value.efi_disk
  initialization        = each.value.initialization
  memory                = each.value.memory
  network_device        = each.value.network_device
  operating_system_type = each.value.operating_system_type
  rng_source            = each.value.rng_source
  vga                   = each.value.vga
}
