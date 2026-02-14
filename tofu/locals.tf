locals {
  lan_cidr   = cidrsubnet(var.vm_data_storage_ipv4_address, 0, 0)
  lan_prefix = split("/", local.lan_cidr)[1]
  vm_data_db_ipv4_address = coalesce(
    var.vm_data_db_ipv4_address,
    format("%s/%s", cidrhost(local.lan_cidr, 203), local.lan_prefix),
  )
  vm_games_minecraft_ipv4_address = coalesce(
    var.vm_games_minecraft_ipv4_address,
    format("%s/%s", cidrhost(local.lan_cidr, 210), local.lan_prefix),
  )
  vm_k3s_prod_ipv4_address = coalesce(
    var.vm_k3s_prod_ipv4_address,
    cidrhost(local.lan_cidr, 204),
  )
  vmbr0_address = format(
    "%s/24",
    cidrhost(local.lan_cidr, 20),
  )
}
