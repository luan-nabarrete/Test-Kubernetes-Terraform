#!/bin/bash
echo "User data executado" >> /tmp/userdata.log


yum update -y
yum install -y git

# Install kind, helm and kubectl
curl -Lo ./kind https://kind.sigs.k8s.io/dl/v0.20.0/kind-linux-amd64
chmod +x ./kind
mv ./kind /usr/local/bin/kind

curl https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3 | bash

curl -LO "https://dl.k8s.io/release/$(curl -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
chmod +x kubectl
mv kubectl /usr/local/bin/


mkdir /home/ec2-user/nginx-web-server/

cd /home/ec2-user/nginx-web-server/

git init
git remote add origin https://github.com/luan-nabarrete/Test-Kubernetes-Terraform.git

git config core.sparseCheckout true
echo "helm/" >> .git/info/sparse-checkout

git pull origin main

kind create cluster --name nginx-web-server-cluster --config ./kind-app-nginx-cluster.yaml



