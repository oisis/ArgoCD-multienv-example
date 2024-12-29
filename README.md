# ArgoCD-multienv-example
ArgoCD multi-environment example

### 1. Prerequisites
* [Docker desktop](https://www.docker.com/products/docker-desktop/)
* [Minikube](https://minikube.sigs.k8s.io/docs/start/?arch=%2Fmacos%2Farm64%2Fstable%2Fbinary+download)
* [kubectl](https://kubernetes.io/docs/tasks/tools/)
* [argocd](https://argo-cd.readthedocs.io/en/stable/cli_installation/)
* [helm](https://helm.sh/docs/intro/install/)

### 2. Run Docker desktop

### 3. Set up git repository(if you made own copy of this one):
* Update link to your repository
  * **DEV environment**:
    * [bootstrap/manifests/dev/argocd-repos-secret.yaml](bootstrap/manifests/dev/argocd-repos-secret.yaml) line: 11
    * [bootstrap/manifests/dev/helm-aoa-appset.yaml](bootstrap/manifests/dev/helm-aoa-appset.yaml) lines: 14, 28, 39, 44
    * [envs/dev/argocd/manifests/helm-aoa-appset.yaml](envs/dev/argocd/manifests/helm-aoa-appset.yaml) lines: 14, 30, 41, 46
    * [envs/dev/argocd/manifests/k8s-manifests-aoa-appset.yaml](envs/dev/argocd/manifests/k8s-manifests-aoa-appset.yaml) lines: 14, 30, 35
  * **SIT environment**:
    * [bootstrap/manifests/sit/argocd-repos-secret.yaml](bootstrap/manifests/sit/argocd-repos-secret.yaml) line: 11
    * [bootstrap/manifests/sit/helm-aoa-appset.yaml](bootstrap/manifests/sit/helm-aoa-appset.yaml) lines: 14, 28, 39, 44
    * [envs/sit/argocd/manifests/helm-aoa-appset.yaml](envs/sit/argocd/manifests/helm-aoa-appset.yaml) lines: 14, 30, 41, 46
    * [envs/sit/argocd/manifests/k8s-manifests-aoa-appset.yaml](envs/sit/argocd/manifests/k8s-manifests-aoa-appset.yaml) lines: 14, 30, 35

### 4. Install ArgoCD
#### 4.1 Install with Helm
* Add `ArgoCD` `Helm` repo:
```bash
helm repo add argocd https://argoproj.github.io/argo-helm
```

* *Update `Helm` local repos cache
```bash
helm repo update
```

* Install `ArgoCD` with `Helm`
```bash
helm install argocd argocd/argo-cd --version 7.7.11 \
  -f ./bootstrap/helm/argocd-values.yaml \
  --create-namespace \
  -n argocd
```

#### 4.2 Install ArgoCD in Argo way
* Create namespace for `ArgoCD`
```bash
kubectl create namespace argocd
```

* Install ArgoCD from Kubernetes manifest file(all in one)
```bash
kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml
```

* Patch Kubernetes Service, change type to LoadBalancer
```bash
kubectl patch svc argocd-server -n argocd -p '{"spec": {"type": "LoadBalancer"}}'
```

### 5. Bootstrap ArgoCD
* Apply Kubernetes manifests to finish ArgoCD bootstraping
Create Repositories, Cluster(local), ApplicationOfApplications(ApplicationSet)
```bash
kubectl apply -f ./bootstrap/manifests/dev/
```

### 6. Get default ArgoCD password
```bash
argocd admin initial-password -n argocd | head -n 1
```

### 7. Open ArgoCD ui
```bash
kubectl port-forward svc/argocd-server -n argocd 8080:443
```
Open `http://localhost:8080` in web browser

### 8. Change ArgoCD default password
```bash
argocd login localhost:8080
argocd account update-password
```

**HOWTO**:
* Destroy cluster created with `minikube`:
```bash
minikube delete
```
* Get access to Kubernetes dashboard included to `minikube` installation:
```bash
minikube dashboard
```
* Switch between `minikube` clusters:
```bash
minikube profile <CLUSTER_NAME>
```