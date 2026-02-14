# Agent Guidelines

## Core Principles
1. **Plan First**: create a plan in `plans/` (format: `YYYY-MM-DD-name.md`) before any code if the change is big
2. **No Hardcoded Secrets**: Use `make secrets` to add them to the cluster
3. **Follow Patterns**: Mimic existing deployments in `manifests/`
4. **GitOps with FluxCD**: Flux automatically syncs all manifests from GitHub. Commit changes and they will be applied

## Infrastructure
- **Cluster**: k3s
- **GitOps**: FluxCD (syncs from github.com/nzagorsky/infra)
- **Ingress**: Traefik
- **TLS**: Wildcard cert for `*.home.${BASE_DOMAIN:=example.com}` (cert-manager + Cloudflare DNS)
- **Storage**: `nfs-storage` (primary) and `smb` (shared media)

## Namespaces
- `media`: Jellyfin, Transmission
- `n8n`: Workflows
- `gluetun`: VPN proxy
- `searxng`: Search
- `crawl4ai`: Web crawling

## Key Services

### Proxy (VPN)
- **DNS**: `gluetun-proxy.gluetun.svc.cluster.local:8888`

### Cluster Variables (Flux post-build)
- **Source**: `ConfigMap/cluster-vars` in `flux-system`
- **Keys**: `BASE_DOMAIN`, `ACME_EMAIL`

### TLS Certificates
- **Secret**: `wildcard-home-tls`
- **Reflection**: Add new namespaces to `infrastructure/cert-manager.yaml:30`

## Deployment Pattern
```
Namespace → PVC (nfs-storage) → ConfigMap → Deployment → Service → Ingress
```

### Environment Variables
- `PUID/PGID`: "1001"
- `TZ`: Timezone (e.g., "America/New_York")
- `SEARXNG_SECRET`: Generate with `openssl rand -hex 32` once

### Ingress Pattern
```yaml
ingressClassName: traefik
tls:
  - secretName: wildcard-home-tls
    hosts: ["*.home.${BASE_DOMAIN:=example.com}"]
```

## Makefile Targets
- `make secrets`: Create namespaces and secrets
- `make init`: Install server packages (qemu-guest-agent, avahi-daemon, docker)
- `make up`: Install/update k3s
- `make shell`: SSH to server
- `make bootstrap`: Bootstrap FluxCD on cluster
- `make status`: Show all Flux resources
- `make reconcile`: Force Flux to sync Git repository
- `make check`: Verify Flux prerequisites

## Storage
- **NFS** (`nfs-storage`): Use for app data, cache, configs. Typical sizes: 500Mi-10Gi
- **SMB** (`smb`): Use only for shared media access
