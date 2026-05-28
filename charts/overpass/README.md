# Overpass Helm Chart

This is a WIP Overpass server helm chart.
Your feedback and contributions are most welcome.

## Volume permissions

The upstream `b1tw153/overpass-api` image runs as UID/GID `10001` and does
**not** chown its data volume on start. This chart deliberately does not set
`fsGroup` either — auto-chowning a large Overpass DB at every pod start can
take a long time. The PV backing `overpass-data-<hash>` must be writeable by
UID `10001` before the pod is scheduled. The easiest ways to get there:

- **k3s / Rancher local-path** — works out of the box. The provisioner
  creates the directory mode `0777`, so any UID can write.
- **Owned by `10001:10001`** — pre-create the PVC and run a one-shot
  `chown -R 10001:10001` job against it before deploying. Required again
  whenever `storage.revision` is bumped (which creates a new PVC).
- **Storage class with ownership control** — if your CSI driver lets you
  set ownership at provision time, configure that on the storage class.

Forgetting this will manifest as `Permission denied` errors from the
initContainer with very sparse logs.

## Network Hardening

This helm chart is ready to use in a "default deny" networking environment.
However, that strictness isn't enforced when you install the helm chart.
You can do this yourself with something like:

```
# Default deny all ingress and egress in the Overpass namespace
apiVersion: networking.k8s.io/v1
kind: NetworkPolicy
metadata:
  name: default-deny-all
  namespace: overpass-namespace
spec:
  podSelector: {}
  policyTypes:
    - Ingress
    - Egress
```
