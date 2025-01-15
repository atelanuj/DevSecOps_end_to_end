# DevSecOps Project

## MicroService Application Architecture
![image](https://user-images.githubusercontent.com/29688323/179655923-e5d9ed72-176e-4956-897c-c1bb434d5c63.jpg)

## Pipeline Flow
![image](https://github.com/user-attachments/assets/4c1f4ff4-fe4a-4672-b00e-a8832f44ed89)

## Project Overview

This project involves the following key components:

1. **Infrastructure Setup**:
    - **Terraform** is used to provision the AWS infrastructure, including VPC, subnets, EC2 instances, and security groups.
    - EC2 instances host essential DevSecOps tools such as Jenkins and SonarQube.
2. **Application Setup**:
    - **Ansible** is used to automate the setup of Jenkins, SonarQube, and other tools on EC2 instances.
    - Kubernetes hosts the 3-tier application, which includes frontend, backend, and database tiers.
3. **DevSecOps CI/CD Pipeline**:
    - Github Actions orchestrates the CI pipeline, integrating with tools like SonarQube for static code analysis and OWASP Dependency-Check for vulnerability scanning.
    - Docker images are scanned with Trivy before being pushed to Docker Hub.
    - ArgoCD handles the Continuous Deployment (CD) process to Kubernetes.
4. **Monitoring and Observability**:
    - Prometheus and Grafana provide monitoring and observability for the Kubernetes cluster and application.

## Kubernetes Architecture
![image](https://github.com/user-attachments/assets/17a5dc5f-98e1-4a06-9a89-2a67bdf0c94b)


