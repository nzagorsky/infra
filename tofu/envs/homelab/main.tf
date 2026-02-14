resource "proxmox_virtual_environment_vm" "data_storage" {
  name                                 = "data-storage"
  node_name                            = local.vm_node_name
  vm_id                                = 202
  description                          = <<-EOT
    NFS export: <nfs-server>:/srv/nfs/k8s

    # Path
    ```
    nfs.internal.example.invalid
    ```

    ### Test oneliner
    ```bash
    sudo apt-get update -y && sudo apt-get install -y --no-install-recommends nfs-common && sudo mkdir -p /mnt/k8s-nfs && sudo mount -t nfs -o vers=4.1,proto=tcp <nfs-server>:/srv/nfs/k8s /mnt/k8s-nfs && echo "ok" | sudo tee /mnt/k8s-nfs/_nfs_test_$(hostname -s)_$(date -u +%Y%m%dT%H%M%SZ).txt >/dev/null && ls -lah /mnt/k8s-nfs | tail

    ```
  EOT
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
  keyboard_layout                      = "en-us"
  scsi_hardware                        = "virtio-scsi-single"
  started                              = true
  stop_on_destroy                      = false
  tablet_device                        = true
  tags                                 = []
  template                             = false

  agent {
    enabled = local.vm_agent_defaults.enabled
    type    = local.vm_agent_defaults.type
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
    size         = 53
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
        address = var.vm_data_storage_ipv4_address
        gateway = var.vm_default_ipv4_gateway
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
    bridge      = local.vm_network_defaults.bridge
    model       = local.vm_network_defaults.model
    mac_address = var.vm_data_storage_mac_address
    firewall    = false
    enabled     = local.vm_network_defaults.enabled
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
      keyboard_layout,
      agent[0].type,
      description,
      initialization[0].user_account[0].password,
    ]
  }
}

resource "proxmox_virtual_environment_vm" "data_db" {
  name                                 = "data-db"
  node_name                            = local.vm_node_name
  vm_id                                = 203
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
  keyboard_layout                      = "en-us"
  scsi_hardware                        = "virtio-scsi-single"
  started                              = true
  stop_on_destroy                      = false
  tablet_device                        = true
  tags                                 = []
  template                             = false

  agent {
    enabled = local.vm_agent_defaults.enabled
    type    = local.vm_agent_defaults.type
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
        address = var.vm_data_db_ipv4_address
        gateway = var.vm_default_ipv4_gateway
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
    bridge      = local.vm_network_defaults.bridge
    model       = local.vm_network_defaults.model
    mac_address = var.vm_data_db_mac_address
    firewall    = false
    enabled     = local.vm_network_defaults.enabled
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
      keyboard_layout,
      agent[0].type,
      initialization[0].user_account[0].password,
    ]
  }
}

resource "proxmox_virtual_environment_vm" "k3s_prod" {
  name                                 = "k3s-prod"
  node_name                            = local.vm_node_name
  vm_id                                = 204
  description                          = "Router DHCP bind to ${var.vm_k3s_prod_ipv4_address}"
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
  keyboard_layout                      = "en-us"
  scsi_hardware                        = "virtio-scsi-single"
  started                              = true
  stop_on_destroy                      = false
  tablet_device                        = true
  tags                                 = []
  template                             = false

  agent {
    enabled = local.vm_agent_defaults.enabled
    type    = local.vm_agent_defaults.type
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
    dedicated = 8192
    floating  = local.vm_memory_defaults.floating
    shared    = local.vm_memory_defaults.shared
  }

  network_device {
    bridge      = local.vm_network_defaults.bridge
    model       = local.vm_network_defaults.model
    mac_address = var.vm_k3s_prod_mac_address
    firewall    = false
    enabled     = local.vm_network_defaults.enabled
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
      keyboard_layout,
      agent[0].type,
      initialization[0].user_account[0].password,
    ]
  }
}

resource "proxmox_virtual_environment_vm" "games_minecraft" {
  name                                 = "games-minecraft"
  node_name                            = local.vm_node_name
  vm_id                                = 210
  description                          = ""
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
  keyboard_layout                      = "en-us"
  scsi_hardware                        = "virtio-scsi-single"
  started                              = true
  stop_on_destroy                      = false
  tablet_device                        = true
  tags                                 = []
  template                             = false

  agent {
    enabled = local.vm_agent_defaults.enabled
    type    = local.vm_agent_defaults.type
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
        address = var.vm_games_minecraft_ipv4_address
        gateway = var.vm_default_ipv4_gateway
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
    dedicated = 6144
    floating  = local.vm_memory_defaults.floating
    shared    = local.vm_memory_defaults.shared
  }

  network_device {
    bridge      = local.vm_network_defaults.bridge
    model       = local.vm_network_defaults.model
    mac_address = var.vm_games_minecraft_mac_address
    firewall    = true
    enabled     = local.vm_network_defaults.enabled
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
      keyboard_layout,
      agent[0].type,
      initialization[0].user_account[0].password,
    ]
  }
}
