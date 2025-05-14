#!/bin/bash
echo "User data executado com sucesso!" >> /tmp/userdata.log

# Install Git and Docker
yum update -y
yum install -y git docker

systemctl start docker.service
systemctl enable docker.service

# Install kind, helm and kubectl
curl -Lo ./kind https://kind.sigs.k8s.io/dl/v0.20.0/kind-linux-amd64
chmod +x ./kind
mv ./kind /usr/local/bin/kind

curl https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3 | bash

curl -LO "https://dl.k8s.io/release/v1.30.1/bin/linux/amd64/kubectl"
chmod +x kubectl
mv kubectl /usr/local/bin/

# Cloning helm dir from repo
mkdir /home/ec2-user/nginx-web-server/
cd /home/ec2-user/nginx-web-server/
git init
git remote add origin https://github.com/luan-nabarrete/Test-Kubernetes-Terraform.git
git config core.sparseCheckout true
echo "helm/" >> .git/info/sparse-checkout
git pull origin main

# Create kind cluster
kind create cluster --name nginx-web-server-cluster --config ./helm/kind-app-nginx-cluster.yaml
mkdir -p /root/.kube
kind get kubeconfig --name nginx-web-server-cluster > /root/.kube/config
kubectl config use-context kind-nginx-web-server-cluster

# Install Helm Chart
helm install nginx-web-server ./helm/