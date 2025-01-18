#/bin/bash

sudo apt update -y
sudo apt install docker.io -y
sudo usermod -aG docker $USER && newgrp docker

sudo chmod +x install_kind.sh
./install_kind.sh

sudo chmod +x install_kubectl.sh
./install_kubectl.sh

kind create cluster --config=config.yml
kubectl cluster-info --context kind-kind
kubectl get nodes
kind get clusters
alias k="kubectl"
alias d="docker"