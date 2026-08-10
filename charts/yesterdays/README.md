# Yesterdays Helm Chart

The official helm chart for [Yesterdays](https://github.com/MapRVA/yesterdays)

> [!IMPORTANT]  
> The official name of this helm chart is `georeference-tool`, for historical reasons.

## Dependencies

The Wikidata subject mirror lives in [Memgraph](https://memgraph.com), pulled in as a subchart. When
working with this chart from a local checkout, vendor it first:

```sh
helm repo add memgraph https://memgraph.github.io/helm-charts
helm dependency update charts/yesterdays
```

Memgraph settings live under the `memgraph:` key in `values.yaml` and are passed straight through to
the upstream chart. Two exceptions are worth knowing about:

- **Metrics** are driven by this chart's own `metrics:` block, not the subchart's. The subchart is
  configured to serve OpenMetrics directly (`scrapeMemgraphDirectly`) with its own ServiceMonitor
  disabled, and this chart creates the ServiceMonitor.
- **The Grafana dashboard** (`memgraph.prometheus.grafanaDashboard.enabled`) is a subchart value, so
  it cannot follow `metrics.enabled` and renders unconditionally.
- **`memgraph.fullnameOverride`** is pinned to `yesterdays-memgraph` and the app templates address
  the Service by that name, so don't change it. It also works around an upstream bug: the subchart
  truncates its generated name to 63 characters and *then* appends suffixes like `-lib-storage`,
  which produces invalid volume names under a long release name.
