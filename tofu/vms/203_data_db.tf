resource "proxmox_virtual_environment_vm" "vm_203_data_db" {
  name      = "data-db"
  node_name = var.proxmox_node_name
  vm_id     = 203

  description = <<-EOT
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
  keyboard_layout                      = null
  scsi_hardware                        = "virtio-scsi-single"
  started                              = true
  stop_on_destroy                      = false
  tablet_device                        = true
  tags                                 = []
  template                             = false

  agent {
    enabled = true
    type    = null
    trim    = true
    timeout = "15m"
  }

  cpu {
    cores   = 4
    sockets = 1
    numa    = false
    type    = "host"
  }

  disk {
    interface    = "scsi0"
    datastore_id = "local-lvm"
    size         = 28
    file_format  = "raw"
    discard      = "on"
    iothread     = true
    aio          = "io_uring"
    cache        = "none"
    backup       = true
    replicate    = true
    ssd          = true
  }

  initialization {
    datastore_id = "local-lvm"
    interface    = "ide2"

    ip_config {
      ipv4 {
        address = local.vm_data_db_ipv4_address
        gateway = var.vm_default_ipv4_gateway
      }
      ipv6 {
        address = "dhcp"
      }
    }

    user_account {
      username = var.vm_default_username
      keys     = var.vm_default_ssh_keys
    }
  }

  memory {
    dedicated = 8192
    floating  = 0
    shared    = 0
  }

  network_device {
    bridge      = "vmbr0"
    model       = "virtio"
    mac_address = var.vm_data_db_mac_address
    firewall    = false
    enabled     = true
  }

  operating_system {
    type = "l26"
  }

  rng {
    source = "/dev/urandom"
  }

  vga {
    type   = "qxl"
    memory = 16
  }

  lifecycle {
    prevent_destroy = true
    ignore_changes = [
      description,
      initialization,
      initialization[0].ip_config,
      keyboard_layout,
      agent[0].type,
      initialization[0].user_account[0].password,
      network_device[0].mac_address,
    ]
  }
}
