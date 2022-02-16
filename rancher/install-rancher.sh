#!/bin/sh
# Licensed under the CC0 1.0

set -x

if [ "$#" -ne 5 ]
then
	echo "Usage $0 <hostname> <email> <clproject> <apikey> <bootstrappassword>"
	exit 1
fi

HOST=$1
EMAIL=$2
PROJECT=$3
APIKEY=$4
BOOTSTRAPPASSWORD=$5

apt update
apt install -y apt-transport-https ca-certificates curl gnupg-agent software-properties-common

tee /root/cluster.yml <<EOF
nodes:
   - address: $HOST
     user: root
     role: [controlplane,etcd,worker]
     ssh_key_path: /root/.ssh/id_rsa
addon_job_timeout: 120
EOF

tee /root/glesys-node-driver.yml <<EOF
apiVersion: management.cattle.io/v3
kind: NodeDriver
metadata:
  annotations:
    lifecycle.cattle.io/create.node-driver-controller: "true"
    privateCredentialFields: password
  labels:
    cattle.io/creator: norman
  name: glesys
spec:
  active: true
  builtin: false
  checksum: ""
  description: "GleSYS Cloud Node Driver"
  displayName: GleSYS
  externalId: ""
  uiUrl: ""
  url: https://github.com/glesys/docker-machine-driver-glesys/releases/download/v1.1.0/docker-machine-driver-glesys_linux-amd64
EOF

tee /root/disable-driver.yml <<EOF
spec:
  active: false
EOF

tee /root/glesys-node-template-kvm.yml <<EOF
---
apiVersion: management.cattle.io/v3
glesysConfig:
  apiKey: $APIKEY
  bandwidth: "100"
  campaignCode: ""
  cpu: "2"
  dataCenter: Falkenberg
  memory: "4096"
  platform: KVM
  project: $PROJECT
  rootPassword: ""
  sshKeyPath: ""
  storage: "20"
  template: ubuntu-20-04
  usernameKvm: docker-machine
kind: NodeTemplate
metadata:
  annotations:
    ownerBindingsCreated: "false"
  name: glesys-kvm-falkenberg-small
  namespace: cattle-global-nt
  labels:
    Datacenter: Falkenberg
spec:
  displayName: KVM Falkenberg Small (2vCPU, 4GB RAM, 20GB Disk)
  driver: glesys
  engineInstallURL: https://releases.rancher.com/install-docker/20.10.sh
  engineRegistryMirror: null
  useInternalIpAddress: true
---
apiVersion: management.cattle.io/v3
glesysConfig:
  apiKey: $APIKEY
  bandwidth: "100"
  campaignCode: ""
  cpu: "4"
  dataCenter: Falkenberg
  memory: "8192"
  platform: KVM
  project: $PROJECT
  rootPassword: ""
  sshKeyPath: ""
  storage: "60"
  template: ubuntu-20-04
  usernameKvm: docker-machine
kind: NodeTemplate
metadata:
  annotations:
    ownerBindingsCreated: "false"
  name: glesys-kvm-falkenberg-medium
  namespace: cattle-global-nt
  labels:
    Datacenter: Falkenberg
spec:
  displayName: KVM Falkenberg Medium (4vCPU, 8GB RAM, 60GB Disk)
  driver: glesys
  engineInstallURL: https://releases.rancher.com/install-docker/20.10.sh
  engineRegistryMirror: null
  useInternalIpAddress: true
---
apiVersion: management.cattle.io/v3
glesysConfig:
  apiKey: $APIKEY
  bandwidth: "100"
  campaignCode: ""
  cpu: "16"
  dataCenter: Falkenberg
  memory: "32768"
  platform: KVM
  project: $PROJECT
  rootPassword: ""
  sshKeyPath: ""
  storage: "150"
  template: ubuntu-20-04
  usernameKvm: docker-machine
kind: NodeTemplate
metadata:
  annotations:
    ownerBindingsCreated: "false"
  name: glesys-kvm-falkenberg-large
  namespace: cattle-global-nt
  labels:
    Datacenter: Falkenberg
spec:
  displayName: KVM Falkenberg Large (16vCPU, 32GB RAM, 150GB Disk)
  driver: glesys
  engineInstallURL: https://releases.rancher.com/install-docker/20.10.sh
  engineRegistryMirror: null
  useInternalIpAddress: true
---
apiVersion: management.cattle.io/v3
glesysConfig:
  apiKey: $APIKEY
  bandwidth: "100"
  campaignCode: ""
  cpu: "2"
  dataCenter: Stockholm
  memory: "4096"
  platform: KVM
  project: $PROJECT
  rootPassword: ""
  sshKeyPath: ""
  storage: "20"
  template: ubuntu-20-04
  usernameKvm: docker-machine
kind: NodeTemplate
metadata:
  annotations:
    ownerBindingsCreated: "false"
  name: glesys-kvm-stockholm-small
  namespace: cattle-global-nt
  labels:
    Datacenter: Stockholm
spec:
  displayName: KVM Stockholm Small (2vCPU, 4GB RAM, 20GB Disk)
  driver: glesys
  engineInstallURL: https://releases.rancher.com/install-docker/20.10.sh
  engineRegistryMirror: null
  useInternalIpAddress: true
---
apiVersion: management.cattle.io/v3
glesysConfig:
  apiKey: $APIKEY
  bandwidth: "100"
  campaignCode: ""
  cpu: "4"
  dataCenter: Stockholm
  memory: "8192"
  platform: KVM
  project: $PROJECT
  rootPassword: ""
  sshKeyPath: ""
  storage: "60"
  template: ubuntu-20-04
  usernameKvm: docker-machine
kind: NodeTemplate
metadata:
  annotations:
    ownerBindingsCreated: "false"
  name: glesys-kvm-stockholm-medium
  namespace: cattle-global-nt
  labels:
    Datacenter: Stockholm
spec:
  displayName: KVM Stockholm Medium (4vCPU, 8GB RAM, 60GB Disk)
  driver: glesys
  engineInstallURL: https://releases.rancher.com/install-docker/20.10.sh
  engineRegistryMirror: null
  useInternalIpAddress: true
---
apiVersion: management.cattle.io/v3
glesysConfig:
  apiKey: $APIKEY
  bandwidth: "100"
  campaignCode: ""
  cpu: "16"
  dataCenter: Stockholm
  memory: "32768"
  platform: KVM
  project: $PROJECT
  rootPassword: ""
  sshKeyPath: ""
  storage: "150"
  template: ubuntu-20-04
  usernameKvm: docker-machine
kind: NodeTemplate
metadata:
  annotations:
    ownerBindingsCreated: "false"
  name: glesys-kvm-stockholm-large
  namespace: cattle-global-nt
  labels:
    Datacenter: Stockholm
spec:
  displayName: KVM Stockholm Large (16vCPU, 32GB RAM, 150GB Disk)
  driver: glesys
  engineInstallURL: https://releases.rancher.com/install-docker/20.10.sh
  engineRegistryMirror: null
  useInternalIpAddress: true
EOF


# Create SSH keys
ssh-keygen -f /root/.ssh/id_rsa -P "" -q
cat /root/.ssh/id_rsa.pub >> /root/.ssh/authorized_keys

# Install Docker
curl https://releases.rancher.com/install-docker/20.10.sh | sh

### Download dependency

# rke
wget https://github.com/rancher/rke/releases/download/v1.3.7/rke_linux-amd64
mv rke_linux-amd64 /usr/local/bin/rke
chmod +x  /usr/local/bin/rke

# kubectl
curl -LO https://storage.googleapis.com/kubernetes-release/release/v1.23.3/bin/linux/amd64/kubectl
mv kubectl /usr/local/bin/
chmod +x  /usr/local/bin/kubectl

# helm
wget https://get.helm.sh/helm-v3.8.0-linux-amd64.tar.gz
tar zxvf helm-v3.8.0-linux-amd64.tar.gz
mv linux-amd64/helm /usr/local/bin/
chmod +x  /usr/local/bin/helm

## Setup RKE kube cluster to run rancher in
rke up --config /root/cluster.yml

# Export config variables
export KUBECONFIG=/root/kube_config_cluster.yml
export HOME=/root

# Install Certmanager
kubectl apply -f https://github.com/cert-manager/cert-manager/releases/download/v1.7.1/cert-manager.crds.yaml
kubectl create namespace cert-manager
helm repo add jetstack https://charts.jetstack.io
helm repo update
helm install   cert-manager jetstack/cert-manager   --namespace cert-manager   --create-namespace  --version v1.7.1
kubectl -n cert-manager rollout status deploy/cert-manager


sleep 60

# Install Rancher
helm repo add rancher-stable https://releases.rancher.com/server-charts/stable
kubectl create namespace cattle-system
helm install rancher rancher-stable/rancher \
   --namespace cattle-system \
   --set hostname=$HOST \
   --set ingress.tls.source=letsEncrypt \
   --set letsEncrypt.email=$EMAIL \
   --set bootstrapPassword=$BOOTSTRAPPASSWORD

kubectl -n cattle-system rollout status deploy/rancher

# Patch away other node drivers and cloud providers.
kubectl patch nodedrivers.management.cattle.io -n cattle-system --type merge --patch "$(cat /root/disable-driver.yml)" amazonec2
kubectl patch nodedrivers.management.cattle.io -n cattle-system --type merge --patch "$(cat /root/disable-driver.yml)" digitalocean
kubectl patch nodedrivers.management.cattle.io -n cattle-system --type merge --patch "$(cat /root/disable-driver.yml)" azure
kubectl patch nodedrivers.management.cattle.io -n cattle-system --type merge --patch "$(cat /root/disable-driver.yml)" linode
kubectl patch nodedrivers.management.cattle.io -n cattle-system --type merge --patch "$(cat /root/disable-driver.yml)" vmwarevsphere
kubectl patch nodedrivers.management.cattle.io -n cattle-system --type merge --patch "$(cat /root/disable-driver.yml)" harvester
kubectl patch kontainerdrivers.management.cattle.io -n cattle-system --type merge --patch "$(cat /root/disable-driver.yml)" amazonelasticcontainerservice
kubectl patch kontainerdrivers.management.cattle.io -n cattle-system --type merge --patch "$(cat /root/disable-driver.yml)" azurekubernetesservice
kubectl patch kontainerdrivers.management.cattle.io -n cattle-system --type merge --patch "$(cat /root/disable-driver.yml)" googlekubernetesengine
kubectl patch kontainerdrivers.management.cattle.io -n cattle-system --type merge --patch "$(cat /root/disable-driver.yml)" rancherkubernetesengine

# Install Glesys node driver and example template
kubectl apply -f  /root/glesys-node-driver.yml  -n cattle-system
kubectl apply -f /root/glesys-node-template-kvm.yml
