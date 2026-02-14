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
