# Cucumbernetes

Initial kubernetes cluster for building quick PoC's and experiments.
My personal playground filled with frequently used set ups' and favourite k8s [tech stack](./docs.md).

# Local cluster development with Kind

Run the following script to bootstrap default local cluster with [Kind](https://kind.sigs.k8s.io/docs/user/quick-start/):
```bash
bash ./provision/scripts/local_env/bootstrap_kind.sh
```

Run the following command to delete the Kind cluster:
```bash
kind delete cluster --name cucumbernetes
```

# Flux

Scripts to bootstrap cluster with GitOps: 

* with github:

```bash
bash ./provision/scripts/fluxcd/fluxcd_bootstrap_github.sh
```

* with gitlab:

```bash
export GITLAB_TOKEN=${gitlab_token}

bash ./provision/scripts/fluxcd/fluxcd_bootstrap_gitlab.sh
```


# Provision in clouds

## AWS

## GCP

## DO

# References

* [Kind: Quck start](https://kind.sigs.k8s.io/docs/user/quick-start/)
* [Kubectl: install](https://kubernetes.io/docs/tasks/tools/install-kubectl-linux/)