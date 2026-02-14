output "vm_inventory" {
  value = {
    "130-azerothcore" = {
      vm_id     = proxmox_virtual_environment_vm.azerothcore.vm_id
      node_name = proxmox_virtual_environment_vm.azerothcore.node_name
      name      = proxmox_virtual_environment_vm.azerothcore.name
    }
    "200-haos" = {
      vm_id     = proxmox_virtual_environment_vm.haos.vm_id
      node_name = proxmox_virtual_environment_vm.haos.node_name
      name      = proxmox_virtual_environment_vm.haos.name
    }
    "202-data-storage" = {
      vm_id     = proxmox_virtual_environment_vm.data_storage.vm_id
      node_name = proxmox_virtual_environment_vm.data_storage.node_name
      name      = proxmox_virtual_environment_vm.data_storage.name
    }
    "203-data-db" = {
      vm_id     = proxmox_virtual_environment_vm.data_db.vm_id
      node_name = proxmox_virtual_environment_vm.data_db.node_name
      name      = proxmox_virtual_environment_vm.data_db.name
    }
    "204-k3s-prod" = {
      vm_id     = proxmox_virtual_environment_vm.k3s_prod.vm_id
      node_name = proxmox_virtual_environment_vm.k3s_prod.node_name
      name      = proxmox_virtual_environment_vm.k3s_prod.name
    }
    "205-k3s-dev" = {
      vm_id     = proxmox_virtual_environment_vm.k3s_dev.vm_id
      node_name = proxmox_virtual_environment_vm.k3s_dev.node_name
      name      = proxmox_virtual_environment_vm.k3s_dev.name
    }
    "210-games-minecraft" = {
      vm_id     = proxmox_virtual_environment_vm.games_minecraft.vm_id
      node_name = proxmox_virtual_environment_vm.games_minecraft.node_name
      name      = proxmox_virtual_environment_vm.games_minecraft.name
    }
    "500-tailscale" = {
      vm_id     = proxmox_virtual_environment_vm2.tailscale.id
      node_name = proxmox_virtual_environment_vm2.tailscale.node_name
      name      = proxmox_virtual_environment_vm2.tailscale.name
    }
    "9001-ubuntu-24-04-cloud" = {
      vm_id     = proxmox_virtual_environment_vm.ubuntu_24_04_cloud_template.vm_id
      node_name = proxmox_virtual_environment_vm.ubuntu_24_04_cloud_template.node_name
      name      = proxmox_virtual_environment_vm.ubuntu_24_04_cloud_template.name
    }
  }
}
