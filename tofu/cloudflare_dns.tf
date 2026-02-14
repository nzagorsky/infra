locals {
  nfs_lab_ipv4_address = split("/", var.vm_data_storage_ipv4_address)[0]
}

resource "cloudflare_dns_record" "nas_lab" {
  zone_id = var.cloudflare_zone_id
  name    = "nas.lab"
  content = var.nas_lab_ipv4_address
  type    = "A"
  ttl     = 1
  proxied = false
}

resource "cloudflare_dns_record" "nfs_lab" {
  zone_id = var.cloudflare_zone_id
  name    = "nfs.lab"
  content = local.nfs_lab_ipv4_address
  type    = "A"
  ttl     = 1
  proxied = false
}

resource "cloudflare_dns_record" "wildcard_home" {
  zone_id = var.cloudflare_zone_id
  name    = "*.home"
  content = local.vm_k3s_prod_ipv4_address
  type    = "A"
  ttl     = 60
  proxied = false
}
