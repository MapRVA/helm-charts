# Overpass Helm Chart

This is a WIP Overpass server helm chart.
Your feedback and contributions are most welcome.

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
