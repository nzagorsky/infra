moved {
  from = proxmox_virtual_environment_vm.data_storage
  to   = module.vms["data_storage"].proxmox_virtual_environment_vm.this
}

moved {
  from = proxmox_virtual_environment_vm.data_db
  to   = module.vms["data_db"].proxmox_virtual_environment_vm.this
}

moved {
  from = proxmox_virtual_environment_vm.k3s_prod
  to   = module.vms["k3s_prod"].proxmox_virtual_environment_vm.this
}

moved {
  from = proxmox_virtual_environment_vm.games_minecraft
  to   = module.vms["games_minecraft"].proxmox_virtual_environment_vm.this
}

moved {
  from = proxmox_virtual_environment_vm.haos
  to   = module.vms["haos"].proxmox_virtual_environment_vm.this
}

moved {
  from = proxmox_virtual_environment_vm.azerothcore
  to   = module.vms["azerothcore"].proxmox_virtual_environment_vm.this
}

moved {
  from = proxmox_virtual_environment_vm.k3s_dev
  to   = module.vms["k3s_dev"].proxmox_virtual_environment_vm.this
}

moved {
  from = proxmox_virtual_environment_vm.ubuntu_24_04_cloud_template
  to   = module.vms["ubuntu_24_04_cloud_template"].proxmox_virtual_environment_vm.this
}
