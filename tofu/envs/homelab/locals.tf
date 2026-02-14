locals {
  vm_node_name = var.proxmox_node_name
  lan_cidr     = cidrsubnet(var.vm_data_storage_ipv4_address, 0, 0)
  lan_prefix   = split("/", local.lan_cidr)[1]
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

  vm_agent_defaults = {
    enabled = true
    type    = "virtio"
    trim    = true
    timeout = "15m"
  }

  vm_cpu_defaults = {
    sockets = 1
    numa    = false
    type    = "host"
  }

  vm_disk_defaults = {
    interface    = "scsi0"
    datastore_id = "local-lvm"
    file_format  = "raw"
    discard      = "on"
    iothread     = true
    aio          = "io_uring"
    cache        = "none"
    backup       = true
    replicate    = true
    ssd          = true
  }

  vm_initialization_defaults = {
    datastore_id = "local-lvm"
    interface    = "ide2"
    ipv6_address = "dhcp"
    username     = var.vm_default_username
    keys         = ["ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIG/U9J4gbyz+Tu3MGcsgbSEA7I4T06+UA/66d7LD55uk nzagorsky"]
  }

  vm_memory_defaults = {
    floating = 0
    shared   = 0
  }

  vm_network_defaults = {
    bridge  = "vmbr0"
    model   = "virtio"
    enabled = true
  }

  vm_os_type    = "l26"
  vm_rng_source = "/dev/urandom"
  vm_vga = {
    type   = "qxl"
    memory = 16
  }

  vm_resource_defaults = {
    description                          = null
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
    agent = {
      enabled = local.vm_agent_defaults.enabled
      type    = null
      trim    = local.vm_agent_defaults.trim
      timeout = local.vm_agent_defaults.timeout
    }
    cpu = {
      cores   = 2
      sockets = local.vm_cpu_defaults.sockets
      numa    = local.vm_cpu_defaults.numa
      type    = local.vm_cpu_defaults.type
    }
    disk = {
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
    efi_disk = null
    initialization = {
      datastore_id = local.vm_initialization_defaults.datastore_id
      interface    = local.vm_initialization_defaults.interface
      dns_servers  = []
      ipv4_address = "dhcp"
      ipv4_gateway = null
      ipv6_address = local.vm_initialization_defaults.ipv6_address
      username     = local.vm_initialization_defaults.username
      keys         = local.vm_initialization_defaults.keys
    }
    memory = {
      dedicated = 4096
      floating  = local.vm_memory_defaults.floating
      shared    = local.vm_memory_defaults.shared
    }
    network_device = {
      bridge      = local.vm_network_defaults.bridge
      model       = local.vm_network_defaults.model
      mac_address = null
      firewall    = false
      enabled     = local.vm_network_defaults.enabled
    }
    operating_system_type = local.vm_os_type
    rng_source            = local.vm_rng_source
    vga = {
      type   = local.vm_vga.type
      memory = local.vm_vga.memory
    }
  }

  vm_specs = {
    data_storage = merge(local.vm_resource_defaults, {
      name        = "data-storage"
      vm_id       = 202
      description = <<-EOT
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
      cpu = merge(local.vm_resource_defaults.cpu, {
        cores = 2
      })
      disk = merge(local.vm_resource_defaults.disk, {
        size = 53
      })
      initialization = merge(local.vm_resource_defaults.initialization, {
        ipv4_address = var.vm_data_storage_ipv4_address
        ipv4_gateway = var.vm_default_ipv4_gateway
      })
      memory = merge(local.vm_resource_defaults.memory, {
        dedicated = 4096
      })
      network_device = merge(local.vm_resource_defaults.network_device, {
        mac_address = var.vm_data_storage_mac_address
      })
    })

    data_db = merge(local.vm_resource_defaults, {
      name        = "data-db"
      vm_id       = 203
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
      cpu = merge(local.vm_resource_defaults.cpu, {
        cores = 4
      })
      disk = merge(local.vm_resource_defaults.disk, {
        size = 28
      })
      initialization = merge(local.vm_resource_defaults.initialization, {
        ipv4_address = local.vm_data_db_ipv4_address
        ipv4_gateway = var.vm_default_ipv4_gateway
      })
      memory = merge(local.vm_resource_defaults.memory, {
        dedicated = 8192
      })
      network_device = merge(local.vm_resource_defaults.network_device, {
        mac_address = var.vm_data_db_mac_address
      })
    })

    k3s_prod = merge(local.vm_resource_defaults, {
      name            = "k3s-prod"
      vm_id           = 204
      description     = "Router DHCP bind to ${local.vm_k3s_prod_ipv4_address}"
      keyboard_layout = "en-us"
      agent = merge(local.vm_resource_defaults.agent, {
        type = local.vm_agent_defaults.type
      })
      cpu = merge(local.vm_resource_defaults.cpu, {
        cores = 4
      })
      disk = merge(local.vm_resource_defaults.disk, {
        size = 33
      })
      initialization = merge(local.vm_resource_defaults.initialization, {
        ipv4_address = "dhcp"
      })
      memory = merge(local.vm_resource_defaults.memory, {
        dedicated = 8192
      })
      network_device = merge(local.vm_resource_defaults.network_device, {
        mac_address = var.vm_k3s_prod_mac_address
      })
    })

    games_minecraft = merge(local.vm_resource_defaults, {
      name            = "games-minecraft"
      vm_id           = 210
      description     = ""
      keyboard_layout = "en-us"
      agent = merge(local.vm_resource_defaults.agent, {
        type = local.vm_agent_defaults.type
      })
      cpu = merge(local.vm_resource_defaults.cpu, {
        cores = 4
      })
      disk = merge(local.vm_resource_defaults.disk, {
        size = 28
      })
      initialization = merge(local.vm_resource_defaults.initialization, {
        ipv4_address = local.vm_games_minecraft_ipv4_address
        ipv4_gateway = var.vm_default_ipv4_gateway
      })
      memory = merge(local.vm_resource_defaults.memory, {
        dedicated = 6144
      })
      network_device = merge(local.vm_resource_defaults.network_device, {
        mac_address = var.vm_games_minecraft_mac_address
        firewall    = true
      })
    })

    haos = merge(local.vm_resource_defaults, {
      name  = "HAOS"
      vm_id = 200
      bios  = "ovmf"
      cpu = merge(local.vm_resource_defaults.cpu, {
        cores = 2
        type  = "x86-64-v2-AES"
      })
      disk = merge(local.vm_resource_defaults.disk, {
        size = 32
        ssd  = false
      })
      efi_disk = {
        datastore_id      = local.vm_disk_defaults.datastore_id
        file_format       = local.vm_disk_defaults.file_format
        pre_enrolled_keys = false
        type              = "4m"
      }
      initialization = null
      memory = merge(local.vm_resource_defaults.memory, {
        dedicated = 4096
      })
      network_device = merge(local.vm_resource_defaults.network_device, {
        firewall = true
      })
      rng_source = null
      vga        = null
    })

    azerothcore = merge(local.vm_resource_defaults, {
      name    = "azerothcore"
      vm_id   = 130
      on_boot = false
      started = false
      cpu = merge(local.vm_resource_defaults.cpu, {
        cores = 6
      })
      disk = merge(local.vm_resource_defaults.disk, {
        size = 33
      })
      initialization = merge(local.vm_resource_defaults.initialization, {
        ipv4_address = "dhcp"
      })
      memory = merge(local.vm_resource_defaults.memory, {
        dedicated = 12288
      })
      network_device = merge(local.vm_resource_defaults.network_device, {
        firewall = false
      })
      vga = null
    })

    k3s_dev = merge(local.vm_resource_defaults, {
      name  = "k3s-dev"
      vm_id = 205
      cpu = merge(local.vm_resource_defaults.cpu, {
        cores = 4
      })
      disk = merge(local.vm_resource_defaults.disk, {
        size = 28
      })
      initialization = merge(local.vm_resource_defaults.initialization, {
        ipv4_address = "dhcp"
      })
      memory = merge(local.vm_resource_defaults.memory, {
        dedicated = 8192
      })
      network_device = merge(local.vm_resource_defaults.network_device, {
        firewall = false
      })
    })

    ubuntu_24_04_cloud_template = merge(local.vm_resource_defaults, {
      name     = "ubuntu-24-04-cloud"
      vm_id    = 9001
      started  = false
      template = true
      cpu = merge(local.vm_resource_defaults.cpu, {
        cores = 2
      })
      disk = merge(local.vm_resource_defaults.disk, {
        size = 13
      })
      initialization = merge(local.vm_resource_defaults.initialization, {
        dns_servers  = ["1.1.1.1"]
        ipv4_address = "dhcp"
      })
      memory = merge(local.vm_resource_defaults.memory, {
        dedicated = 4096
      })
      network_device = merge(local.vm_resource_defaults.network_device, {
        firewall = true
      })
    })
  }

  vm_inventory_keys = {
    data_storage                = "202-data-storage"
    data_db                     = "203-data-db"
    k3s_prod                    = "204-k3s-prod"
    games_minecraft             = "210-games-minecraft"
    haos                        = "200-haos"
    azerothcore                 = "130-azerothcore"
    k3s_dev                     = "205-k3s-dev"
    ubuntu_24_04_cloud_template = "9001-ubuntu-24-04-cloud"
  }
}
