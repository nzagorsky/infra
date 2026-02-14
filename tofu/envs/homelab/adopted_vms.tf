resource "proxmox_virtual_environment_vm" "haos" {
  name                                 = "HAOS"
  node_name                            = local.vm_node_name
  vm_id                                = 200
  acpi                                 = true
  bios                                 = "ovmf"
  boot_order                           = ["scsi0"]
  delete_unreferenced_disks_on_destroy = true
  machine                              = "q35"
  migrate                              = false
  on_boot                              = true
  protection                           = false
  purge_on_destroy                     = true
  reboot                               = false
  reboot_after_update                  = true
  scsi_hardware                        = "virtio-scsi-single"
  started                              = true
  stop_on_destroy                      = false
  tablet_device                        = true
  tags                                 = []
  template                             = false

  agent {
    enabled = local.vm_agent_defaults.enabled
    trim    = local.vm_agent_defaults.trim
    timeout = local.vm_agent_defaults.timeout
  }

  cpu {
    cores   = 2
    sockets = local.vm_cpu_defaults.sockets
    numa    = local.vm_cpu_defaults.numa
    type    = "x86-64-v2-AES"
  }

  disk {
    interface    = local.vm_disk_defaults.interface
    datastore_id = local.vm_disk_defaults.datastore_id
    size         = 32
    file_format  = local.vm_disk_defaults.file_format
    discard      = local.vm_disk_defaults.discard
    iothread     = local.vm_disk_defaults.iothread
    aio          = local.vm_disk_defaults.aio
    cache        = local.vm_disk_defaults.cache
    backup       = local.vm_disk_defaults.backup
    replicate    = local.vm_disk_defaults.replicate
    ssd          = false
  }

  efi_disk {
    datastore_id      = local.vm_disk_defaults.datastore_id
    file_format       = local.vm_disk_defaults.file_format
    pre_enrolled_keys = false
    type              = "4m"
  }

  memory {
    dedicated = 4096
    floating  = local.vm_memory_defaults.floating
    shared    = local.vm_memory_defaults.shared
  }

  network_device {
    bridge   = local.vm_network_defaults.bridge
    model    = local.vm_network_defaults.model
    firewall = true
    enabled  = local.vm_network_defaults.enabled
  }

  operating_system {
    type = local.vm_os_type
  }

  lifecycle {
    prevent_destroy = true
    ignore_changes = [
      description,
      initialization,
      keyboard_layout,
      agent[0].type,
      network_device[0].mac_address,
    ]
  }
}

resource "proxmox_virtual_environment_vm" "azerothcore" {
  name                                 = "azerothcore"
  node_name                            = local.vm_node_name
  vm_id                                = 130
  acpi                                 = true
  bios                                 = "seabios"
  boot_order                           = ["scsi0"]
  delete_unreferenced_disks_on_destroy = true
  machine                              = "q35"
  migrate                              = false
  on_boot                              = false
  protection                           = false
  purge_on_destroy                     = true
  reboot                               = false
  reboot_after_update                  = true
  scsi_hardware                        = "virtio-scsi-single"
  started                              = false
  stop_on_destroy                      = false
  tablet_device                        = true
  tags                                 = []
  template                             = false

  agent {
    enabled = local.vm_agent_defaults.enabled
    trim    = local.vm_agent_defaults.trim
    timeout = local.vm_agent_defaults.timeout
  }

  cpu {
    cores   = 6
    sockets = local.vm_cpu_defaults.sockets
    numa    = local.vm_cpu_defaults.numa
    type    = local.vm_cpu_defaults.type
  }

  disk {
    interface    = local.vm_disk_defaults.interface
    datastore_id = local.vm_disk_defaults.datastore_id
    size         = 33
    file_format  = local.vm_disk_defaults.file_format
    discard      = local.vm_disk_defaults.discard
    iothread     = local.vm_disk_defaults.iothread
    aio          = local.vm_disk_defaults.aio
    cache        = local.vm_disk_defaults.cache
    backup       = local.vm_disk_defaults.backup
    replicate    = local.vm_disk_defaults.replicate
    ssd          = local.vm_disk_defaults.ssd
  }

  initialization {
    datastore_id = local.vm_initialization_defaults.datastore_id
    interface    = local.vm_initialization_defaults.interface

    ip_config {
      ipv4 {
        address = "dhcp"
      }
      ipv6 {
        address = local.vm_initialization_defaults.ipv6_address
      }
    }

    user_account {
      username = local.vm_initialization_defaults.username
      keys     = local.vm_initialization_defaults.keys
    }
  }

  memory {
    dedicated = 12288
    floating  = local.vm_memory_defaults.floating
    shared    = local.vm_memory_defaults.shared
  }

  network_device {
    bridge   = local.vm_network_defaults.bridge
    model    = local.vm_network_defaults.model
    firewall = false
    enabled  = local.vm_network_defaults.enabled
  }

  operating_system {
    type = local.vm_os_type
  }

  rng {
    source = local.vm_rng_source
  }

  lifecycle {
    prevent_destroy = true
    ignore_changes = [
      description,
      keyboard_layout,
      agent[0].type,
      initialization[0].user_account[0].password,
      network_device[0].mac_address,
    ]
  }
}

resource "proxmox_virtual_environment_vm" "k3s_dev" {
  name                                 = "k3s-dev"
  node_name                            = local.vm_node_name
  vm_id                                = 205
  acpi                                 = true
  bios                                 = "seabios"
  boot_order                           = ["scsi0"]
  delete_unreferenced_disks_on_destroy = true
  machine                              = "q35"
  migrate                              = false
  on_boot                              = true
  protection                           = false
  purge_on_destroy                     = true
  reboot                               = false
  reboot_after_update                  = true
  scsi_hardware                        = "virtio-scsi-single"
  started                              = true
  stop_on_destroy                      = false
  tablet_device                        = true
  tags                                 = []
  template                             = false

  agent {
    enabled = local.vm_agent_defaults.enabled
    trim    = local.vm_agent_defaults.trim
    timeout = local.vm_agent_defaults.timeout
  }

  cpu {
    cores   = 4
    sockets = local.vm_cpu_defaults.sockets
    numa    = local.vm_cpu_defaults.numa
    type    = local.vm_cpu_defaults.type
  }

  disk {
    interface    = local.vm_disk_defaults.interface
    datastore_id = local.vm_disk_defaults.datastore_id
    size         = 28
    file_format  = local.vm_disk_defaults.file_format
    discard      = local.vm_disk_defaults.discard
    iothread     = local.vm_disk_defaults.iothread
    aio          = local.vm_disk_defaults.aio
    cache        = local.vm_disk_defaults.cache
    backup       = local.vm_disk_defaults.backup
    replicate    = local.vm_disk_defaults.replicate
    ssd          = local.vm_disk_defaults.ssd
  }

  initialization {
    datastore_id = local.vm_initialization_defaults.datastore_id
    interface    = local.vm_initialization_defaults.interface

    ip_config {
      ipv4 {
        address = "dhcp"
      }
      ipv6 {
        address = local.vm_initialization_defaults.ipv6_address
      }
    }

    user_account {
      username = local.vm_initialization_defaults.username
      keys     = local.vm_initialization_defaults.keys
    }
  }

  memory {
    dedicated = 8192
    floating  = local.vm_memory_defaults.floating
    shared    = local.vm_memory_defaults.shared
  }

  network_device {
    bridge   = local.vm_network_defaults.bridge
    model    = local.vm_network_defaults.model
    firewall = false
    enabled  = local.vm_network_defaults.enabled
  }

  operating_system {
    type = local.vm_os_type
  }

  rng {
    source = local.vm_rng_source
  }

  vga {
    type   = local.vm_vga.type
    memory = local.vm_vga.memory
  }

  lifecycle {
    prevent_destroy = true
    ignore_changes = [
      description,
      keyboard_layout,
      agent[0].type,
      initialization[0].ip_config,
      initialization[0].user_account[0].password,
      network_device[0].mac_address,
    ]
  }
}

resource "proxmox_virtual_environment_vm2" "tailscale" {
  name      = "tailscale"
  node_name = var.proxmox_node_name

  delete_unreferenced_disks_on_destroy = true
  purge_on_destroy                     = true
  stop_on_destroy                      = false
  description                          = <<-EOT
    wget https://cloud-images.ubuntu.com/noble/current/noble-server-cloudimg-amd64.img -O /root/ubuntu-24.04-cloudimg-amd64.img

    qm create 9001 --name ubuntu-24-04-cloud --memory 1024 --cpu host --cores 2 --sockets 1 --net0 virtio,bridge=vmbr0 --ostype l26 --scsihw virtio-scsi-single --machine q35
    qm set 9001 --scsi0 local-lvm:0,import-from=/root/ubuntu-24.04-cloudimg-amd64.img,discard=on,ssd=1,iothread=1

    qm set 9001 --ide2 local-lvm:cloudinit
    qm set 9001 --boot order=scsi0
    qm set 9001 --agent enabled=1,fstrim_cloned_disks=1
    qm set 9001 --rng0 source=/dev/urandom
    qm set 9001 --vga qxl
    qm set 9001 --tablet 1

    qm template 9001
  EOT

  cdrom = {
    ide2 = {
      file_id = "local-lvm:vm-500-cloudinit"
    }
  }

  cpu = {
    cores   = 2
    sockets = 1
    type    = "host"
  }

  rng = {
    source = "/dev/urandom"
  }

  vga = {
    type = "qxl"
  }

  tags = []

  lifecycle {
    prevent_destroy = true
    ignore_changes = [
      cpu,
      description,
      rng,
      vga,
    ]
  }
}

resource "proxmox_virtual_environment_vm" "ubuntu_24_04_cloud_template" {
  name                                 = "ubuntu-24-04-cloud"
  node_name                            = local.vm_node_name
  vm_id                                = 9001
  acpi                                 = true
  bios                                 = "seabios"
  boot_order                           = ["scsi0"]
  delete_unreferenced_disks_on_destroy = true
  machine                              = "q35"
  migrate                              = false
  on_boot                              = true
  protection                           = false
  purge_on_destroy                     = true
  reboot                               = false
  reboot_after_update                  = true
  scsi_hardware                        = "virtio-scsi-single"
  started                              = false
  stop_on_destroy                      = false
  tablet_device                        = true
  tags                                 = []
  template                             = true

  agent {
    enabled = local.vm_agent_defaults.enabled
    trim    = local.vm_agent_defaults.trim
    timeout = local.vm_agent_defaults.timeout
  }

  cpu {
    cores   = 2
    sockets = local.vm_cpu_defaults.sockets
    numa    = local.vm_cpu_defaults.numa
    type    = local.vm_cpu_defaults.type
  }

  disk {
    interface    = local.vm_disk_defaults.interface
    datastore_id = local.vm_disk_defaults.datastore_id
    size         = 13
    file_format  = local.vm_disk_defaults.file_format
    discard      = local.vm_disk_defaults.discard
    iothread     = local.vm_disk_defaults.iothread
    aio          = local.vm_disk_defaults.aio
    cache        = local.vm_disk_defaults.cache
    backup       = local.vm_disk_defaults.backup
    replicate    = local.vm_disk_defaults.replicate
    ssd          = local.vm_disk_defaults.ssd
  }

  initialization {
    datastore_id = local.vm_initialization_defaults.datastore_id
    interface    = local.vm_initialization_defaults.interface

    dns {
      servers = ["1.1.1.1"]
    }

    ip_config {
      ipv4 {
        address = "dhcp"
      }
      ipv6 {
        address = local.vm_initialization_defaults.ipv6_address
      }
    }

    user_account {
      username = local.vm_initialization_defaults.username
      keys     = local.vm_initialization_defaults.keys
    }
  }

  memory {
    dedicated = 4096
    floating  = local.vm_memory_defaults.floating
    shared    = local.vm_memory_defaults.shared
  }

  network_device {
    bridge   = local.vm_network_defaults.bridge
    model    = local.vm_network_defaults.model
    firewall = true
    enabled  = local.vm_network_defaults.enabled
  }

  operating_system {
    type = local.vm_os_type
  }

  rng {
    source = local.vm_rng_source
  }

  vga {
    type   = local.vm_vga.type
    memory = local.vm_vga.memory
  }

  lifecycle {
    prevent_destroy = true
    ignore_changes = [
      description,
      keyboard_layout,
      agent[0].type,
      initialization[0].user_account[0].password,
      network_device[0].mac_address,
    ]
  }
}
