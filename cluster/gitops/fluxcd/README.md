# Fluxcd

* [Flux installation options](https://fluxcd.io/docs/installation/)
* [Flux bootstrap with Kustomize](https://fluxcd.io/legacy/flux/tutorials/get-started-kustomize/)
* [Flux with SOPS](https://fluxcd.io/docs/guides/mozilla-sops/)
* [Rehat blog about Flux & SOPS](https://cloud.redhat.com/blog/a-guide-to-secrets-management-with-gitops-and-kubernetes)
* [Flux monitoring](https://fluxcd.io/docs/guides/monitoring/)

# Flux bootstrap options

## Github repository

```bash
flux bootstrap git \
  --url=ssh://git@${host}/${org}/${repository} \
  --branch=${gitlab_branch} \
  --path=${cluster}
```

## Gitlab repository

```bash
export GITHUB_TOKEN=${gitlab_token}

flux bootstrap gitlab \
  --hostname=${gitlab_hostname}
  --repository=${gitlab_repository} \
  --branch=${gitlab_branch}
  --path=${cluster} \
  --token-auth \
  --personal
```

# Flux first run

```bash
kubectl apply -k fluxcd                           # Apply flux deployment
kubectl -n flux rollout status deployment/flux    # Await to bootstrap
```

# Flux configuration with Kustomize

# Flux summary: useful commands

**Debug Flux**

```bash
flux logs --all-namespaces --since=2m                                 # Print all logs of all Flux custom resources newer than 2 minutes
flux logs --follow --level=error --all-namespaces                     # Stream logs for a particular log level
flux logs --kind=Kustomization --name=${app_name} --namespace=${ns}   # Filter logs by kind, name and namespace
flux logs --flux-namespace=${ns}                                      # Print logs when Flux is installed in a different namespace than flux-system
kubectl get events -n flux-system                                     # Get all events related to the Flux system
```

**Debug helmreleases**
```bash
kubectl describe HelmRelease -n ${ns} ${app_name}                     # Overview HelmRelease resource state
kubectl get HelmRelease -n ${ns} -o yaml ${app_name}                  # Overview HelmRelease as an API object
helm get manifest ${app_name} -n ${ns}                                # Check how rendered Helm chart for the app looks like by the k8s cluster
flux reconcile hr ${app_name} -n ${ns}                                # Reconcile resource managed by Flux if resource wasn't updated automatically
```