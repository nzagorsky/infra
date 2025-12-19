nfs.home.example.com:/srv/nfs/k8s (clients from NFS_CLIENT_CIDR)

# Path

```
nfs.home.example.com
```

### Test oneliner

```bash
sudo apt-get update -y && sudo apt-get install -y --no-install-recommends nfs-common && sudo mkdir -p /mnt/k8s-nfs && sudo mount -t nfs -o vers=4.1,proto=tcp nfs.home.example.com:/srv/nfs/k8s /mnt/k8s-nfs && echo "ok" | sudo tee /mnt/k8s-nfs/_nfs_test_$(hostname -s)_$(date -u +%Y%m%dT%H%M%SZ).txt >/dev/null && ls -lah /mnt/k8s-nfs | tail

```
