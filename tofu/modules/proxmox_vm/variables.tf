variable "name" {
  type = string
}

variable "node_name" {
  type = string
}

variable "vm_id" {
  type = number
}

variable "description" {
  type     = string
  default  = null
  nullable = true
}

variable "acpi" {
  type    = bool
  default = true
}

variable "bios" {
  type = string
}

variable "boot_order" {
  type = list(string)
}

variable "delete_unreferenced_disks_on_destroy" {
  type    = bool
  default = true
}

variable "machine" {
  type = string
}

variable "migrate" {
  type = bool
}

variable "on_boot" {
  type = bool
}

variable "protection" {
  type = bool
}

variable "purge_on_destroy" {
  type    = bool
  default = true
}

variable "reboot" {
  type = bool
}

variable "reboot_after_update" {
  type = bool
}

variable "keyboard_layout" {
  type     = string
  default  = null
  nullable = true
}

variable "scsi_hardware" {
  type = string
}

variable "started" {
  type = bool
}

variable "stop_on_destroy" {
  type    = bool
  default = false
}

variable "tablet_device" {
  type = bool
}

variable "tags" {
  type    = list(string)
  default = []
}

variable "template" {
  type = bool
}

variable "agent" {
  type = object({
    enabled = bool
    type    = optional(string)
    trim    = bool
    timeout = string
  })
}

variable "cpu" {
  type = object({
    cores   = number
    sockets = number
    numa    = bool
    type    = string
  })
}

variable "disk" {
  type = object({
    interface    = string
    datastore_id = string
    size         = number
    file_format  = string
    discard      = string
    iothread     = bool
    aio          = string
    cache        = string
    backup       = bool
    replicate    = bool
    ssd          = bool
  })
}

variable "efi_disk" {
  type = object({
    datastore_id      = string
    file_format       = string
    pre_enrolled_keys = bool
    type              = string
  })
  default  = null
  nullable = true
}

variable "initialization" {
  type = object({
    datastore_id = string
    interface    = string
    dns_servers  = optional(list(string))
    ipv4_address = string
    ipv4_gateway = optional(string)
    ipv6_address = string
    username     = string
    keys         = list(string)
  })
  default  = null
  nullable = true
}

variable "memory" {
  type = object({
    dedicated = number
    floating  = number
    shared    = number
  })
}

variable "network_device" {
  type = object({
    bridge      = string
    model       = string
    mac_address = optional(string)
    firewall    = bool
    enabled     = bool
  })
}

variable "operating_system_type" {
  type = string
}

variable "rng_source" {
  type     = string
  default  = null
  nullable = true
}

variable "vga" {
  type = object({
    type   = string
    memory = optional(number)
  })
  default  = null
  nullable = true
}
