#!/usr/bin/env bash
set -euo pipefail

# Minimal Cockpit + NFS export on Ubuntu, using the root filesystem.
# Exports: /srv/nfs/k8s to your LAN (requires NFS_CLIENT_CIDR).

# if [[ "${EUID:-$(id -u)}" -ne 0 ]]; then
#     echo "Run as root (sudo)." >&2
#     exit 1
# fi

export DEBIAN_FRONTEND=noninteractive

sudo apt-get update -y
sudo apt-get install -y --no-install-recommends cockpit nfs-kernel-server

sudo systemctl enable --now cockpit.socket
sudo systemctl enable --now nfs-server

sudo mkdir -p /srv/nfs/k8s
sudo chmod 0777 /srv/nfs/k8s

if [[ -z "${NFS_CLIENT_CIDR:-}" ]]; then
    echo "NFS_CLIENT_CIDR is required (example: 10.0.0.0/24)." >&2
    exit 1
fi

cidr="${NFS_CLIENT_CIDR}"

sudo mkdir -p /etc/exports.d/

sudo bash -c "cat >/etc/exports.d/k8s.exports <<'EOF'
/srv/nfs/k8s ${cidr}(rw,sync,no_subtree_check,no_root_squash)
EOF"

sudo exportfs -ra

ip="$(hostname -I | awk '{print $1}')"
echo "Cockpit: https://${ip}:9090"
echo "NFS: ${ip}:/srv/nfs/k8s (clients ${cidr})"
