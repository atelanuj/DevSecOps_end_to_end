# Copilot Instructions for DevSecOps_end_to_end

## Project Overview
- This is a real-time, end-to-end microservices-based voting application, designed for DevSecOps learning and automation.
- Major components:
  - **Frontend**: Python web app for voting (see `vote/`)
  - **Redis**: Message broker for votes (see `k8s-specifications/redis-deployment.yaml`)
  - **Worker**: .NET service to process votes (see `worker/`)
  - **Postgres**: Database for persistent storage (see `k8s-specifications/db-*`)
  - **Result**: Node.js app for real-time results (see `result/`)
- Infrastructure and automation are managed with **Kubernetes**, **Docker**, **Ansible**, and **Terraform**.

## Key Workflows
- **Local K8s Cluster**: Use KinD (see `kind-k8s-cluster/README.md`) for local development. Scripts for setup: `install_kind.sh`, `install_kubectl.sh`.
- **CI/CD**: GitHub Actions for CI, ArgoCD for GitOps-based CD. Security scans via Trivy and OWASP.
- **Build/Run**:
  - Build Docker images: see `Docker/Readme.md` for commands and compose usage.
  - Deploy to K8s: Use manifests in `k8s-specifications/` or Helm charts in `Logging/`.
  - Infrastructure provisioning: Use Terraform in `Terraform/EC2 + VPC + EKS/` and Ansible in `Ansible/`.
- **Port Forwarding**: Common for local access (see `README.md` and `kind-k8s-cluster/README.md`). Example:
  ```sh
  kubectl port-forward -n voting-app service/vote 5000:5000 --address=0.0.0.0 &
  ```

## Conventions & Patterns
- **Directory Structure**: Each service/component has its own folder. Infra-as-code and automation scripts are grouped by tool.
- **K8s Manifests**: All core app manifests in `k8s-specifications/`. Logging/monitoring via Helm charts in `Logging/`.
- **Secrets**: Use `db-secrets.yml` for DB credentials. Do not hardcode secrets in code.
- **Windows/Linux**: Some scripts/commands differ by OS (see `Docker/Readme.md`).
- **Helm**: For logging stack (Elasticsearch, Kibana, Filebeat, Logstash), use provided Helm charts and values in `Logging/*/`.

## Integration Points
- **CI/CD**: Integrates GitHub Actions, SonarQube, Trivy, ArgoCD.
- **Cloud**: AWS for EKS, EC2, VPC, IAM (see `Terraform/` and `Ansible/`).
- **Monitoring**: Prometheus and Grafana (see `kind-k8s-cluster/README.md`).

## References
- [README.md](../README.md): High-level architecture, toolchain, and workflow summary
- [kind-k8s-cluster/README.md](../kind-k8s-cluster/README.md): Local cluster setup, tool installation, and access patterns
- [Docker/Readme.md](../Docker/Readme.md): Build/run instructions for containers
- [Ansible/Readme.md](../Ansible/Readme.md): Ansible setup and usage
- [Logging/*/README.md](../Logging/): Helm chart usage for logging/monitoring

## Tips for AI Agents
- Always check for OS-specific instructions in Readme files.
- Use provided scripts for setup and provisioning; avoid manual steps unless necessary.
- Reference the correct namespace and service names when port-forwarding or accessing services.
- For new integrations, follow the patterns in existing K8s manifests and Dockerfiles.
