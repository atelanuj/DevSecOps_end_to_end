# Microservice base voting application Deployment:
- A **front-end web app** in Python which lets you vote between two options
- A **Redis** which collects new votes
- A **.NET worker** which consumes votes and stores them in…
- A **Postgres database** backed by a Docker volume
- A Node.js web app which shows the **results** of the voting in real time

## DevOps CI/CD Flow and Tools
![image](https://github.com/user-attachments/assets/edaf5944-e0d2-4e53-b157-af06f3e57fb0)
- **GitHub Actions:** For continuous Integration (CI) I have used the github actions to automate the security scan and build project.
- **OWASP:** For vulnerabilities scanning in project dependencies (e.g., libraries, frameworks, or packages) to minimize risks associated with third-party libraries and ensure a secure software supply chain.
- **Trivy:** For ensuring continuous security with Trivy helps in scanning like Scanning File Systems, Container Image Scanning and Vulnerability Scanning in Code Repositories etc.
- **Docker:** 📦 containerized the application to ensure portability and consistency across environments.
- **ArgoCD:** leveraged GitOps principles to automate continuous deployments (CD) directly from Git.
- **Kubernetes (k8s):** ⚙️ deployed and managed the containers in a Kubernetes cluster by using managed Kubernetes service by AWS EKS for high availability
- **Prometheus:** It is an open-source monitoring and alerting toolkit designed for reliability and scalability, making it well-suited for dynamic environments like Kubernetes.
- **Grafana:** It enables users to collect, correlate, and visualize data through customizable dashboards, facilitating informed decision-making and streamlined troubleshooting.
- **Ansible:** Infrastructure ****Automation to setup this LAB from provisioning of AWS EC2 and installing all necessary tools like ArgoCD, K8s dashboard, Prometheus and Grafana in one shot
- **Terraform:** Helps in infrastructure provisioning using **IaC** for AWS VPC and EKS and EC2
- **AWS:** Used public cloud like AWS for EKS, EC2, IAM, VPC, ALB and autoscaling services for high availability.

## Voting Application Architecture K8s
![image](https://github.com/user-attachments/assets/f61d7249-d56c-4cbf-91a5-760114dd0452)


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



