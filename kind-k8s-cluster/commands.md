# DevSecOps Local Kubernetes Cluster Setup with KinD

This guide provides step-by-step instructions to set up a local Kubernetes cluster using [KinD (Kubernetes in Docker)](https://kind.sigs.k8s.io/), install essential tools (ArgoCD, Kubernetes Dashboard, Helm, Prometheus, Grafana), and access your applications.

---

## 0. Optional: Git Workflow

Keep your repository up to date with a single command:
```shell
git pull; git add . ; git commit -m "Updated files = $(echo $(git diff-tree --no-commit-id --name-only -r HEAD))" ; git push ; echo "commit = $(git diff-tree --no-commit-id --name-only -r HEAD)"
```

---

## 1. Prerequisites

- **Docker** must be installed and running.

### Install Docker (Ubuntu)
```bash
sudo apt update -y
sudo apt install docker.io -y
sudo usermod -aG docker $USER && newgrp docker
```

---

## 2. Install KinD

### Using Script
```bash
./install_kind.sh
```

### Manual Installation (Linux x86_64)
```bash
[ $(uname -m) = x86_64 ] && curl -Lo ./kind https://kind.sigs.k8s.io/dl/v0.20.0/kind-linux-amd64
chmod +x ./kind
sudo cp ./kind /usr/local/bin/kind
rm -rf kind
```

---

## 3. Install kubectl

```bash
./install_kubectl.sh
# OR
curl -o kubectl https://amazon-eks.s3.us-west-2.amazonaws.com/1.19.6/2021-01-05/bin/linux/amd64/kubectl
chmod +x ./kubectl
sudo mv ./kubectl /usr/local/bin
kubectl version --short --client
```

---

## 4. Create a KinD Cluster

```bash
kind create cluster --config=config.yml
```

**Sample `config.yml`:**
```yaml
kind: Cluster
apiVersion: kind.x-k8s.io/v1alpha4
nodes:
  - role: control-plane
    image: kindest/node:v1.32.0
  - role: worker
    image: kindest/node:v1.32.0
  - role: worker
    image: kindest/node:v1.30.0
```

### Verify Cluster
```bash
kubectl cluster-info --context kind-kind
kubectl get nodes
kind get clusters
```

---

## 5. Install ArgoCD

### Create Namespace
```bash
kubectl create namespace argocd
```

### Install ArgoCD
```bash
kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml
```

### Expose ArgoCD Server (NodePort)
```bash
kubectl patch svc argocd-server -n argocd -p '{"spec": {"type": "NodePort"}}'
```

### Port Forward ArgoCD UI
```bash
kubectl port-forward -n argocd service/argocd-server 8081:443 --address=0.0.0.0 &
```

### Retrieve Initial Admin Password
```bash
kubectl get secret -n argocd argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d && echo
```
- **Username:** `admin`
- **Password:** (output from above command)

![image](https://github.com/user-attachments/assets/9a8d4490-7bc9-4c7b-a6a4-a81d00a703c5)

---

## 6. Install Kubernetes Dashboard

### Create Namespace
```bash
kubectl create ns kubernetes-dashboard
```

### Create ServiceAccount and ClusterRoleBinding
```yaml
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
_Apply the above YAML using `kubectl apply -f <filename>.yaml`_

### Deploy Dashboard
```bash
kubectl apply -f https://raw.githubusercontent.com/kubernetes/dashboard/v2.7.0/aio/deploy/recommended.yaml
```

### Expose Dashboard (NodePort)
```bash
kubectl patch svc kubernetes-dashboard -n kubernetes-dashboard -p '{"spec": {"type": "NodePort"}}'
```

### Port Forward Dashboard
```bash
kubectl port-forward -n kubernetes-dashboard service/kubernetes-dashboard 8082:443 --address=0.0.0.0 &
```

### Get Dashboard Token
```bash
kubectl -n kubernetes-dashboard create token admin-user
```
- Access: [https://``<Machine-IP>``:8082](https://`<Machine-IP>`:8082)

![image](https://github.com/user-attachments/assets/a2e0acae-62ec-432c-bee7-80a27c36b9b8)

---

## 7. Install Helm

```bash
curl -fsSL -o get_helm.sh https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3
chmod +x get_helm.sh
./get_helm.sh
```

---

## 8. Install Prometheus

```bash
kubectl create namespace prometheus
helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
helm repo update
helm install prometheus prometheus-community/prometheus -n prometheus
```

### Port Forward Prometheus
```bash
kubectl port-forward service/prometheus-server -n prometheus 9090:80 --address=0.0.0.0 &
```
- Access: [http://``<Machine-IP>``:9090](http://`<Machine-IP>`:9090)

![image](https://github.com/user-attachments/assets/96b9a79e-9b1d-4118-a59c-07de1dfc5b1b)
---

## 9. Install Grafana

```bash
helm repo add grafana https://grafana.github.io/helm-charts
helm repo update
kubectl create namespace monitoring
helm install my-grafana grafana/grafana --namespace monitoring
kubectl get all -n monitoring
kubectl get secret --namespace monitoring my-grafana -o jsonpath="{.data.admin-password}" | base64 --decode ; echo
```

### Port Forward Grafana
```bash
kubectl --namespace monitoring port-forward service/my-grafana 3000:80 --address=0.0.0.0 &
```
- Access: [http://`<Machine-IP>`:3000](http://`<Machine-IP>`:3000)

### Add Dashboard in Grafana
- Use dashboard code `12740`
- Set Prometheus as the data source

![image](https://github.com/user-attachments/assets/20e16651-789f-4bcf-884c-b35068a5ae11)
---

## 10. Quick Access URLs

| Application           | URL                        | Port Forward Command                                                                 |
|-----------------------|----------------------------|--------------------------------------------------------------------------------------|
| **ArgoCD**            | http://`<Machine-IP>`:8081   | `kubectl port-forward -n argocd service/argocd-server 8081:443 --address=0.0.0.0 &`  |
| **Prometheus**        | http://`<Machine-IP>`:9090   | `kubectl port-forward service/prometheus-server -n prometheus 9090:80 --address=0.0.0.0 &` |
| **Grafana**           | http://`<Machine-IP>`:3000   | `kubectl --namespace monitoring port-forward service/my-grafana 3000:80 --address=0.0.0.0 &` |
| **K8s Dashboard**     | https://`<Machine-IP>`:8082  | `kubectl port-forward -n kubernetes-dashboard service/kubernetes-dashboard 8082:443 --address=0.0.0.0 &` |

---

## Notes

- Replace ``<Machine-IP>`` with your host's IP address.
- For all port-forward commands, use `&` to run in the background.
- For production, consider using Ingress instead of port-forwarding.
- For Windows, use `kubectl.exe` and adjust commands as needed.

---

_This guide helps you bootstrap a local DevSecOps environment for learning.