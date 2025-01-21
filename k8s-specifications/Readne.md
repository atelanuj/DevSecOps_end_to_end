# Run Commands to access the Application
```
kubectl port-forward -n voting-app service/vote 5000:5000 --address=0.0.0.0 &
kubectl port-forward -n voting-app service/result 5001:5001 --address=0.0.0.0 &
```