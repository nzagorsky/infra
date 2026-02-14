output "vm_inventory" {
  value = merge(
    {
      for vm_key, vm in module.vms : local.vm_inventory_keys[vm_key] => {
        vm_id     = vm.vm_id
        node_name = vm.node_name
        name      = vm.name
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
