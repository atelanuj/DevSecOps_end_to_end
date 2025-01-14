# 1. Creating Cluster with KinD (Kubernetes in Docker)

- install Docker
```bash
sudo apt install docker.io -y
sudo usermod -aG docker $USER && newgrp docker
```

- Install KIND
```bash
./install_kind.sh
```
Or
```bash
#!/bin/bash

# For AMD64 / x86_64

[ $(uname -m) = x86_64 ] && curl -Lo ./kind https://kind.sigs.k8s.io/dl/v0.20.0/kind-linux-amd64
chmod +x ./kind
sudo cp ./kind /usr/local/bin/kind
rm -rf kind
```

- install Kubectl
```bash
./install_kubectl.sh
# OR
curl -o kubectl https://amazon-eks.s3.us-west-2.amazonaws.com/1.19.6/2021-01-05/bin/linux/amd64/kubectl
chmod +x ./kubectl
sudo mv ./kubectl /usr/local/bin
kubectl version --short --client
```

- Create Cluster
```bash
kind create cluster --config=config.yml
```

- Check cluster information:
```bash
kubectl cluster-info --context kind-kind
kubectl get nodes
kind get clusters
```

# 2. Install ArgoCD
- Create Namespace
```bash
kubectl create namespace argocd
```

- install ArgoCD
```bash
kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml
```

- Expose Argo CD server using NodePort:
```bash
kubectl patch svc argocd-server -n argocd -p '{"spec": {"type": "NodePort"}}'
```

- Port Forward from Docker 443 to Instance port 8081
```bash
kubectl port-forward -n argocd service/argocd-server 8081:443 --address=0.0.0.0 &
```

- Retrive Initial password
```bash
# Username admin

# Password
kubectl get secret -n argocd argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d && echo
```

# 3. Intall Kubernetes Dashboard
- Create Namespace
```bash
kubectl create ns kubernetes-dashboard
```

- Create K8s ServiceAccount and ClusterRoleBindings
```yml
apiVersion: v1
kind: ServiceAccount
metadata:
  name: admin-user
  namespace: kubernetes-dashboard
---
apiVersion: rbac.authorization.k8s.io/v1
kind: ClusterRoleBinding
metadata:
  name: admin-user
roleRef:
  apiGroup: rbac.authorization.k8s.io
  kind: ClusterRole
  name: cluster-admin
subjects:
- kind: ServiceAccount
  name: admin-user
  namespace: kubernetes-dashboard
```

- Deploy Kubernetes dashboard:
```bash
kubectl apply -f https://raw.githubusercontent.com/kubernetes/dashboard/v2.7.0/aio/deploy/recommended.yaml
```

- patch the service
```bash
kubectl patch svc kubernetes-dashboard -n kubernetes-dashboard -p '{"spec": {"type": "NodePort"}}'
```

- port forword to access dashboard
```bash
kubectl port-forward -n kubernetes-dashboard service/kubernetes-dashboard 8082:443 --address=0.0.0.0 &
```

- Create a token for dashboard access:
```bash
kubectl -n kubernetes-dashboard create token admin-user
```

>note: Use https://Machine-ip:8082 to access the dashboard

# 4. Install HELM
```bash
# download the script
curl -fsSL -o get_helm.sh https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3
# Give permissions to Execute
chmod +x get_helm.sh
# Now Execute the script
./get_helm.sh
```

# 5. Install prometheus

- Install Prometheus
```bash
helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
helm repo add stable https://charts.helm.sh/stable
helm repo update
kubectl create namespace monitoring
helm install kind-prometheus prometheus-community/kube-prometheus-stack --namespace monitoring --set prometheus.service.nodePort=30000 --set prometheus.service.type=NodePort --set grafana.service.nodePort=31000 --set grafana.service.type=NodePort --set alertmanager.service.nodePort=32000 --set alertmanager.service.type=NodePort --set prometheus-node-exporter.service.nodePort=32001 --set prometheus-node-exporter.service.type=NodePort
kubectl get svc -n monitoring
kubectl get namespace
```

- Port-forword to access the prometheus
```bash
kubectl port-forward svc/kind-prometheus-kube-prome-prometheus -n monitoring 9090:9090 --address=0.0.0.0 &
kubectl port-forward svc/kind-prometheus-grafana -n monitoring 31000:80 --address=0.0.0.0 &
```

# 4. Install Grafana
```

```