(EFK observability manifests for development/testing)

This folder contains Kubernetes manifests to deploy a simple, single-node EFK stack (Elasticsearch, Fluent Bit, Kibana) for collecting logs from the frontend and backend applications.

Files added:
- namespace.yaml — Namespace `efk`
- elasticsearch.yaml — Elasticsearch Service + StatefulSet (single-node)
- kibana.yaml — Kibana Deployment + Service
- fluent-bit-rbac.yaml — ServiceAccount + ClusterRole/Binding for Fluent Bit
- fluent-bit-configmap.yaml — Fluent Bit configuration (inputs, filters, outputs)
- fluent-bit-daemonset.yaml — Fluent Bit DaemonSet to collect container logs

Quick deploy (from repo root):

```bash
kubectl apply -f "d:/stuffs/DevOps Learning/Repos/DevSecOps_end_to_end/observability (Not Tested)/EFK/namespace.yaml"
kubectl apply -f "d:/stuffs/DevOps Learning/Repos/DevSecOps_end_to_end/observability (Not Tested)/EFK/" 
```

Notes:
- These manifests are intended for development/demo use only (single-node ES, minimal resources).
- If your cluster uses container runtimes other than Docker (CRI-O/Containerd), adjust `fluent-bit-daemonset.yaml` hostPath mounts accordingly (logs location differs).
- Kibana will be accessible on port 5601 inside the cluster. Use a port-forward to access it locally:

```bash
kubectl -n efk port-forward svc/kibana 5601:5601
# then open http://localhost:5601
```

Index created by Fluent Bit: `kubernetes_logs` (in Elasticsearch)
