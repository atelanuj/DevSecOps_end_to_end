# Run Commands to access the Application
```
kubectl port-forward -n voting-app service/vote 5000:5000 --address=0.0.0.0 &
kubectl port-forward -n voting-app service/result 5001:5001 --address=0.0.0.0 &
```

# Install Nginx Ingress Controller
- create Namespace
```
kubectl create namespace ingress-nginx
```
- install Nginx ingress controller
```
kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/controller-v1.1.2/deploy/static/provider/cloud/deploy.yaml
```