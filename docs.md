# Tech stack 

## CRI-O 

## Linkerd  v2.11:

Check up:

* Linkerd dashboard: `linkerd viz dashboard `  
* Linkerd-Jaegar dashboard: `linkerd jaeger dashboard`

## ArgoCD v2.3.3 

Links:
* [Linkerd with GitOps](https://linkerd.io/2.11/tasks/gitops/)

ArgoCD login:
```bash
password=`kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d` \
&& argocd login 127.0.0.1:8080 \
    --username=admin \
    --password="${password}" \
    --insecure
```
ArgoCD web UI: `kubectl port-forward svc/argocd-server -n argocd 8080:443` 


## Monitoring v1.76.1 

Check up:

* Check up Grafana and Prometheus dashboards

## Goldilocks

Links:
* [Goldilocks](https://github.com/FairwindsOps/goldilocks)

## Vault 1.4.3

Check up:
