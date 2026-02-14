variable "proxmox_endpoint" {
  type        = string
  description = "Proxmox API endpoint"
}

variable "proxmox_insecure" {
  type        = bool
  description = "Skip TLS verification for self-signed certs"
  default     = true
}

variable "proxmox_node_name" {
  type        = string
  description = "Proxmox node name"
  default     = "proxmox"
}

variable "proxmox_dns_domain" {
  type        = string
  description = "DNS search domain configured on the node"
  default     = "local"
}

variable "proxmox_time_zone" {
  type        = string
  description = "Node timezone"
  default     = "America/New_York"
}

variable "cloudflare_zone_id" {
  type        = string
  description = "Cloudflare zone ID for homelab DNS records"
}

variable "nas_lab_ipv4_address" {
  type        = string
  description = "IPv4 address for nas.lab DNS record"
}

variable "vm_default_username" {
  type        = string
  description = "Cloud-init default username for managed VMs"
  default     = "nzagorsky"
}

variable "vm_data_storage_ipv4_address" {
  type        = string
  description = "IPv4 CIDR for data-storage VM"
}

variable "vm_data_db_ipv4_address" {
  type        = string
  description = "IPv4 CIDR for data-db VM (optional, derived from data-storage subnet when unset)"
  default     = null
  nullable    = true
}

variable "vm_games_minecraft_ipv4_address" {
  type        = string
  description = "IPv4 CIDR for games-minecraft VM (optional, derived from data-storage subnet when unset)"
  default     = null
  nullable    = true
}

variable "vm_k3s_prod_ipv4_address" {
  type        = string
  description = "IPv4 address used by router DHCP reservation for k3s-prod (optional, derived from data-storage subnet when unset)"
  default     = null
  nullable    = true
}

variable "vm_default_ipv4_gateway" {
  type        = string
  description = "Default IPv4 gateway for static VM networking"
}

variable "vm_data_storage_mac_address" {
  type        = string
  description = "MAC address for data-storage VM NIC"
}

variable "vm_data_db_mac_address" {
  type        = string
  description = "MAC address for data-db VM NIC"
}

variable "vm_k3s_prod_mac_address" {
  type        = string
  description = "MAC address for k3s-prod VM NIC"
}

variable "vm_games_minecraft_mac_address" {
  type        = string
  description = "MAC address for games-minecraft VM NIC"
}
