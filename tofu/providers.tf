locals {
  # Extract host from something like: https://pve.example.invalid:8006/api2/json
  proxmox_api_hostport = split("/", split("://", var.proxmox_endpoint)[1])[0]
  proxmox_api_host     = split(":", local.proxmox_api_hostport)[0]
}

provider "proxmox" {
  endpoint = var.proxmox_endpoint
  insecure = var.proxmox_insecure

  # Used for operations that Proxmox doesn't fully expose via the API (e.g. snippets).
  # Uses SSH agent by default to avoid managing private keys in state.
  ssh {
    agent    = true
    username = var.proxmox_ssh_username

    node {
      name    = var.proxmox_node_name
      address = local.proxmox_api_host
    }
  }
}

provider "cloudflare" {
}
