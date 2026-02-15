resource "proxmox_virtual_environment_download_file" "ubuntu_24_04_noble_cloud_image" {
  content_type = "import"
  datastore_id = "local"
  node_name    = var.proxmox_node_name

  url       = "https://cloud-images.ubuntu.com/noble/current/noble-server-cloudimg-amd64.img"
  file_name = "noble-server-cloudimg-amd64.qcow2"
}

resource "proxmox_virtual_environment_file" "vm_501_tailscale_canary_user_data" {
  content_type = "snippets"
  datastore_id = "local"
  node_name    = var.proxmox_node_name

  source_raw {
    data = <<-EOF
#cloud-config
manage_etc_hosts: true

package_update: true
packages:
  - qemu-guest-agent
  - curl
  - ca-certificates

users:
  - default
  - name: ${var.vm_default_username}
    groups: [sudo]
    shell: /bin/bash
    sudo: ALL=(ALL) NOPASSWD:ALL
    ssh_authorized_keys:
%{for k in var.vm_default_ssh_keys~}
      - ${k}
%{endfor~}

write_files:
  - path: /etc/sysctl.d/99-tailscale-router.conf
    permissions: "0644"
    content: |
      net.ipv4.ip_forward = 1
      net.ipv6.conf.all.forwarding = 1

runcmd:
  - [ sysctl, --system ]
  - [ systemctl, enable, --now, qemu-guest-agent ]
  - [ sh, -c, "curl -fsSL https://tailscale.com/install.sh | sh" ]
  - [ systemctl, enable, --now, tailscaled ]
EOF

    file_name = "vm-501-tailscale-canary.user-data.yaml"
  }
}

resource "proxmox_virtual_environment_file" "vm_501_tailscale_canary_meta_data" {
  content_type = "snippets"
  datastore_id = "local"
  node_name    = var.proxmox_node_name

  source_raw {
    data = <<-EOF
instance-id: tailscale-canary
local-hostname: tailscale-canary
EOF

    file_name = "vm-501-tailscale-canary.meta-data.yaml"
  }
}

resource "proxmox_virtual_environment_vm" "vm_501_tailscale_canary" {
  name      = "tailscale-canary"
  node_name = var.proxmox_node_name
  vm_id     = 501

  # Tie VM updates to snippet updates so Proxmox cloud-init gets regenerated.
  description = format(
    "cloud-init user=%s meta=%s",
    coalesce(proxmox_virtual_environment_file.vm_501_tailscale_canary_user_data.file_modification_date, "pending"),
    coalesce(proxmox_virtual_environment_file.vm_501_tailscale_canary_meta_data.file_modification_date, "pending"),
  )

  acpi                                 = true
  bios                                 = "seabios"
  boot_order                           = ["scsi0"]
  delete_unreferenced_disks_on_destroy = true
  machine                              = "q35"
  migrate                              = false
  on_boot                              = true
  purge_on_destroy                     = true
  reboot_after_update                  = true
  scsi_hardware                        = "virtio-scsi-single"
  started                              = var.vm_501_tailscale_canary_started
  stop_on_destroy                      = true
  tablet_device                        = true
  template                             = false

  agent {
    enabled = true
    trim    = true
    timeout = "15m"

    wait_for_ip {
      ipv4 = true
    }
  }

  cpu {
    cores   = 2
    sockets = 1
    numa    = false
    type    = "host"
  }

  disk {
    interface    = "scsi0"
    datastore_id = "local-lvm"
    import_from  = proxmox_virtual_environment_download_file.ubuntu_24_04_noble_cloud_image.id
    size         = 8
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
        address = "dhcp"
      }
      ipv6 {
        address = "dhcp"
      }
    }

    user_data_file_id = proxmox_virtual_environment_file.vm_501_tailscale_canary_user_data.id
    meta_data_file_id = proxmox_virtual_environment_file.vm_501_tailscale_canary_meta_data.id
  }

  memory {
    dedicated = 4096
    floating  = 0
    shared    = 0
  }

  network_device {
    bridge   = "vmbr0"
    model    = "virtio"
    firewall = false
    enabled  = true
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
    prevent_destroy = false
    ignore_changes = [
      network_device[0].mac_address,
    ]
  }
}
