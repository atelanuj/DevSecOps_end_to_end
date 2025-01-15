# 1. Creating Cluster with KinD (Kubernetes in Docker)

- install Docker
```bash
sudo apt update -y
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
`config.yml`
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
![image](https://github.com/user-attachments/assets/9a8d4490-7bc9-4c7b-a6a4-a81d00a703c5)


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
![image](https://github.com/user-attachments/assets/a2e0acae-62ec-432c-bee7-80a27c36b9b8)


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
kubectl create namespace prometheus

helm repo add prometheus-community https://prometheus-community.github.io/helm-charts

helm repo update

helm install prometheus prometheus-community/prometheus -n prometheus
```

- Port-forword to access the prometheus
```bash
kubectl port-forward service/prometheus-server -n prometheus 9090:80 --address=0.0.0.0 &
```
![image](https://github.com/user-attachments/assets/96b9a79e-9b1d-4118-a59c-07de1dfc5b1b)


# 4. Install Grafana
- Intall Grafana
```bash
helm repo add grafana https://grafana.github.io/helm-charts

helm repo update

kubectl create namespace monitoring

helm install my-grafana grafana/grafana --namespace monitoring

kubectl get all -n monitoring

kubectl get secret --namespace monitoring my-grafana -o jsonpath="{.data.admin-password}" | base64 --decode ; echo

export POD_NAME=$(kubectl get pods --namespace monitoring -l "app.kubernetes.io/name=grafana,app.kubernetes.io/instance=my-grafana" -o jsonpath="{.items[0].metadata.name}")

```
- Port-forword to access the Grafana
```
kubectl --namespace monitoring port-forward service/my-grafana 3000:80 --address=0.0.0.0 &
```
- Add dashboard in Grafana
```
use code 12740 and datasource as prometheus
```
![image](https://github.com/user-attachments/assets/20e16651-789f-4bcf-884c-b35068a5ae11)


# 5. Accessing Applications
- ArgoCD
```
http://machine-ip:8081
kubectl port-forward -n argocd service/argocd-server 8081:443 --address=0.0.0.0 &
```
- Prometheus
```
http://machine-ip:9090
kubectl port-forward service/prometheus-server -n prometheus 9090:80 --address=0.0.0.0 &
```
- Grafana
```
http://machine-ip:3000
kubectl --namespace monitoring port-forward service/my-grafana 3000:80 --address=0.0.0.0 &
```
- Kubernetes dashboard
```
http://machine-ip:8082
kubectl port-forward -n kubernetes-dashboard service/kubernetes-dashboard 8082:443 --address=0.0.0.0 &
```
