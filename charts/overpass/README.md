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

## Static files and landing page

The `b1tw153/overpass-api` image runs nginx, which serves the contents of
`/opt/overpass/static` at the web root. The image ships default `robots.txt`
and `llms.txt` files there; you can drop in your own `index.html` landing page
or replace those defaults. This chart gives you two ways to do that.

By default the chart ships a minimal `index.html` landing page. Override it
with your own markup (see below), or remove it with `index.html: null`.

### `overpass.staticFiles` — small text files

Map filenames to their contents. Each entry is rendered into a ConfigMap and
overlaid into `/opt/overpass/static` with a per-file `subPath` mount, so you
**only replace the files you list** — the image's defaults remain for anything
you omit (mounting a volume over the whole directory would instead hide them).
Helm deep-merges this map, so adding a key (e.g. `robots.txt`) keeps the
default `index.html` unless you override that key too.

```yaml
overpass:
  staticFiles:
    index.html: |
      <!doctype html>
      <title>Overpass API</title>
      <h1>My Overpass instance</h1>
    robots.txt: |
      User-agent: *
      Disallow: /api/
```

This is best for small text assets. A ConfigMap caps at ~1Mi, and binary files
(images, fonts) have to be base64-encoded — for those, use `extraVolumes`.
Because `subPath` mounts don't live-update when the ConfigMap changes, the
chart stamps a `checksum/static` annotation on the pod so editing these values
rolls the deployment.

### `extraVolumes` / `extraVolumeMounts` — anything else

A generic passthrough for mounting whatever you like into the pod — a
pre-built ConfigMap or Secret, or a PVC holding a larger set of web assets.
`extraVolumeMounts` are added to the `overpass` (nginx) container.

```yaml
extraVolumes:
  - name: landing-assets
    configMap:
      name: my-overpass-landing
extraVolumeMounts:
  - name: landing-assets
    mountPath: /opt/overpass/static/assets
    readOnly: true
```

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
