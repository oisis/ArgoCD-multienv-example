#!/bin/bash

GREEN='\033[0;32m'
RED='\033[0;31m'
NC='\033[0m'

printf "${GREEN}Add ArgoCD Helm repo${NC}\n"
helm repo add argocd https://argoproj.github.io/argo-helm

print "${GREEN} Update Helm local repos cache${NC}\n"
helm repo update

###########
# Cluster-1
###########
printf "${GREEN}Create first K8s cluster: cluster-1${NC}\n"
minikube start --driver=docker \
  --cpus 4 \
  --memory 8192 \
  -p cluster-1

printf "${GREEN}Install ArgoCD with Helm${NC}\n"
helm install argocd argocd/argo-cd --version 7.7.11 \
  -f ./bootstrap/helm/argocd-values.yaml \
  --create-namespace \
  -n argocd

printf "${GREEN}Applying K8s manifests to finish ArgoCD bootstrap${NC}\n"
kubectl apply -f ./bootstrap/manifests/dev/

ARGOPASS=$(argocd admin initial-password -n argocd | head -n 1)
printf "${GREEN}ArgoCD admin password${NC}: ${RED}${ARGOPASS}${NC}\n"

printf "${GREEN}To get access to ArgoCD UI run command:${NC}\n"
printf "    kubectl port-forward svc/argocd-server -n argocd 8080:443\n"
printf "${GREEN}Open http://localhost:8080 in webbrowser${NC}\n"

###########
# Cluster-2
###########
printf "${GREEN}Create second K8s cluster: cluster-2${NC}\n"
minikube start --driver=docker \
  --cpus 4 \
  --memory 8192 \
  -p cluster-2

printf "${GREEN}Install ArgoCD with Helm${NC}\n"
helm install argocd argocd/argo-cd --version 7.7.6 \
  -f ./bootstrap/helm/argocd-values.yaml \
  --create-namespace \
  -n argocd

printf "${GREEN}Applying K8s manifests to finish ArgoCD bootstrap${NC}\n"
kubectl apply -f ./bootstrap/manifests/sit/

ARGOPASS=$(argocd admin initial-password -n argocd | head -n 1)
printf "${GREEN}ArgoCD admin password${NC}: ${RED}${ARGOPASS}${NC}\n"

printf "${GREEN}To get access to ArgoCD UI run command:${NC}\n"
printf "    kubectl port-forward svc/argocd-server -n argocd 8080:443\n"
printf "${GREEN}Open http://localhost:8080 in webbrowser${NC}\n"
