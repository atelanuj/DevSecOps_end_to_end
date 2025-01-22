# Voting Application Architecture
![image](https://github.com/user-attachments/assets/f61d7249-d56c-4cbf-91a5-760114dd0452)

- A **front-end web app** in Python which lets you vote between two options
- A **Redis** which collects new votes
- A **.NET worker** which consumes votes and stores them in…
- A **Postgres database** backed by a Docker volume
- A Node.js web app which shows the **results** of the voting in real time

# Run Commands to access the Application
```
kubectl port-forward -n voting-app service/vote 5000:5000 --address=0.0.0.0 &
kubectl port-forward -n voting-app service/result 5001:5001 --address=0.0.0.0 &
```
---
# Github Actions CI
![image](https://github.com/user-attachments/assets/3e4633ad-c90e-49c8-ab7d-dc8dd76f9164)
![image](https://github.com/user-attachments/assets/3f6a12bc-903f-4648-8f97-e08b9b5ac8df)
---
# K8s Dashboard
![image](https://github.com/user-attachments/assets/bac8960e-fc77-4cc4-a850-910dd0783c19)


---
# ArgoCD
![image](https://github.com/user-attachments/assets/66e48984-1894-4726-b96a-2f76fccd812e)
---
# Grafana
![image](https://github.com/user-attachments/assets/de743eea-ed16-4e03-9b28-f13194384d7e)



