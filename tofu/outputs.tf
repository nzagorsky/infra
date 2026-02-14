output "vm_inventory" {
  value = merge(
    {
      "202-data-storage" = {
        vm_id     = proxmox_virtual_environment_vm.vm_202_data_storage.vm_id
        node_name = proxmox_virtual_environment_vm.vm_202_data_storage.node_name
        name      = proxmox_virtual_environment_vm.vm_202_data_storage.name
      }
      "203-data-db" = {
        vm_id     = proxmox_virtual_environment_vm.vm_203_data_db.vm_id
        node_name = proxmox_virtual_environment_vm.vm_203_data_db.node_name
        name      = proxmox_virtual_environment_vm.vm_203_data_db.name
      }
      "204-k3s-prod" = {
        vm_id     = proxmox_virtual_environment_vm.vm_204_k3s_prod.vm_id
        node_name = proxmox_virtual_environment_vm.vm_204_k3s_prod.node_name
        name      = proxmox_virtual_environment_vm.vm_204_k3s_prod.name
      }
      "205-k3s-dev" = {
        vm_id     = proxmox_virtual_environment_vm.vm_205_k3s_dev.vm_id
        node_name = proxmox_virtual_environment_vm.vm_205_k3s_dev.node_name
        name      = proxmox_virtual_environment_vm.vm_205_k3s_dev.name
      }
      "210-games-minecraft" = {
        vm_id     = proxmox_virtual_environment_vm.vm_210_games_minecraft.vm_id
        node_name = proxmox_virtual_environment_vm.vm_210_games_minecraft.node_name
        name      = proxmox_virtual_environment_vm.vm_210_games_minecraft.name
      }
      "200-haos" = {
        vm_id     = proxmox_virtual_environment_vm.vm_200_haos.vm_id
        node_name = proxmox_virtual_environment_vm.vm_200_haos.node_name
        name      = proxmox_virtual_environment_vm.vm_200_haos.name
      }
      "130-azerothcore" = {
        vm_id     = proxmox_virtual_environment_vm.vm_130_azerothcore.vm_id
        node_name = proxmox_virtual_environment_vm.vm_130_azerothcore.node_name
        name      = proxmox_virtual_environment_vm.vm_130_azerothcore.name
      }
      "9001-ubuntu-24-04-cloud" = {
        vm_id     = proxmox_virtual_environment_vm.vm_9001_ubuntu_24_04_cloud_template.vm_id
        node_name = proxmox_virtual_environment_vm.vm_9001_ubuntu_24_04_cloud_template.node_name
        name      = proxmox_virtual_environment_vm.vm_9001_ubuntu_24_04_cloud_template.name
      }
    },
    {
      "500-tailscale" = {
        vm_id     = proxmox_virtual_environment_vm2.tailscale.id
        node_name = proxmox_virtual_environment_vm2.tailscale.node_name
        name      = proxmox_virtual_environment_vm2.tailscale.name
      }
    },
  )
}
