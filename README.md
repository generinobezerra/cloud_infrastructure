#Install Kubectl
curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
chmod +x kubectl
mv kubectl /usr/local/bin/

kubectl version

#Install Kind
[ $(uname -m) = x86_64 ] && curl -Lo ./kind https://kind.sigs.k8s.io/dl/v0.20.0/kind-linux-amd64
chmod +x ./kind
sudo mv ./kind /usr/local/bin/kind

kind version

#Install Docker
curl -fsSL https://get.docker.com | bash

#Helm
curl -fsSL -o get_helm.sh https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3
chmod 700 get_helm.sh
./get_helm.sh

#Add Repo ingress-nginx
helm repo add ingress-nginx https://kubernetes.github.io/ingress-nginx
helm repo update

#Install Chart
helm install ingress-nginx ingress-nginx/ingress-nginx


#Directory
mkdir app_cloud_infrastructure
cd app_cloud_infrastructure/

cp cloud_infrastructure/* .

#Create environment
helm create app_cloud

#Install environment
helm install web ./app_cloud/


#Clone GIT
git clone git@github.com:generinobezerra/cloud_infrastructure.git
