# Monitoring

This cluster uses a lightweight monitoring stack centered on VictoriaMetrics. It scrapes core Kubernetes and node-level metrics, stores recent data for short-term visibility, and exposes a single metrics endpoint behind Traefik.

## High-Level Components

- **VictoriaMetrics (single-node):** scrapes and stores metrics.
- **Node Exporter (DaemonSet):** collects host/node metrics from each cluster node.
- **Kubernetes scrape jobs:** include API server and cAdvisor-derived container metrics.

## What Is Collected (Brief)

- Cluster/API server health metrics.
- Node CPU, memory, filesystem, and basic host metrics.
- Selected container-level CPU, memory, and filesystem usage metrics.

## Access (Placeholder)

- Metrics endpoint: [https://metrics.home.example.invalid](https://metrics.home.example.invalid)
- Kubernetes service (in-cluster): `victoria-metrics.monitoring.svc.cluster.local:8428`

## Retention and Storage

- Retention window: **14 days**.
- Persistent volume: **5Gi** on `nfs-storage`.

## Related Manifests

- [VictoriaMetrics + node-exporter manifests](../infrastructure/monitoring-victoriametrics.yaml)
- [Infrastructure kustomization](../infrastructure/kustomization.yaml)
