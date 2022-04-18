# ArgoCD

Actual version of ArgoCD is 2.3.3 

## Installation 

1. Install [ArgoCD](https://argo-cd.readthedocs.io/en/stable/getting_started/)

## Check up
1. Get ArgoCD creds: `kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d; echo`
2. Reach ArgoCD web UI: `kubectl port-forward svc/argocd-server -n argocd 8080:443` 