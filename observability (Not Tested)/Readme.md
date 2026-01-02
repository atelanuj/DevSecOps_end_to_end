# Observability Setup Guide

This directory contains the configuration files for a complete observability stack (Logs, Metrics, and Traces) using Grafana, Loki, Tempo, and Fluent Bit.

## Prerequisites
- Helm installed
- Kubectl configured to your cluster

---

## Step 1: Create Namespace
```bash
kubectl create namespace observability
```

## Step 2: Add Helm Repositories
```bash
helm repo add grafana https://grafana.github.io/helm-charts
helm repo update
```

## Step 3: Install Backend Storage (Loki & Tempo)
Apply the storage backends first.
```bash
# Install Tempo (Traces)
helm install tempo grafana/tempo -n observability -f tempo-values.yaml

# Install Loki (Logs)
helm install loki grafana/loki -n observability -f loki-values.yaml
```

## Step 4: Install Grafana with Auto-Discovery
This step installs Grafana and enables the sidecar to automatically discover datasources from ConfigMaps.
```bash
# Install Grafana
helm install grafana grafana/grafana -n observability -f grafana-values.yaml

# Apply Datasource Configuration
kubectl apply -f grafana-datasources-config-map.yaml -n observability
```

## Step 5: Install OpenTelemetry Collector
The collector acts as the central hub for routing traces and logs.
```bash
kubectl apply -f open-telementry-collector-deployment.yaml -n observability
```

## Step 6: Install Fluent Bit (Logs & Metrics)
Fluent Bit will collect logs from the cluster and metrics from nodes, then forward them to the OTel Collector.
```bash
kubectl apply -f namespace-rbac-fluentbit.yaml -n observability
kubectl apply -f fluent-bit-config.yaml -n observability
kubectl apply -f fluent-bit-daemonset.yaml -n observability
```

## Step 7: Update Application Manifests
Finally, apply the updated application manifests (ensure they contain the OTel environment variables).
```bash
kubectl apply -f ../kubernetes/backend.yaml
kubectl apply -f ../kubernetes/frontend.yaml
```

---

### Verification
1. Check all pods are running: `kubectl get pods -n observability`
2. Access Grafana: `kubectl port-forward service/grafana 3000:80 -n observability`
3. Log in (default user `admin`, get password with `kubectl get secret --namespace observability grafana -o jsonpath="{.data.admin-password}" | base64 --decode`)
4. Verify Loki and Tempo datasources are present in **Connections > Data Sources**.


