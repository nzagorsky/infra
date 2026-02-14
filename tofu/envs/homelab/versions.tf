terraform {
  required_version = ">= 1.6.0"

  backend "s3" {}

  required_providers {
    proxmox = {
      source  = "bpg/proxmox"
      version = "~> 0.84"
    }
  }
}
