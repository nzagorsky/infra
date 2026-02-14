terraform {
  required_version = ">= 1.6.0"

  backend "s3" {}

  required_providers {
    cloudflare = {
      source  = "cloudflare/cloudflare"
      version = "~> 5.0"
    }

    proxmox = {
      source  = "bpg/proxmox"
      version = "~> 0.84"
    }
  }
}
