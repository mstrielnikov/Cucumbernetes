# Cucumbernetes

Initial kubernetes cluster for building quick PoC's and experiments.
My personal playground filled with frequently used set ups' and favourite k8s [tech stack](./docs.md).

# Cluster

# Local development with Kind

Run the following script to bootstrap default local cluster with [Kind](https://kind.sigs.k8s.io/docs/user/quick-start/):
```bash
bash ./provision/scripts/local/kind/bootstrap_kind.sh
```

Run the following command to delete the Kind cluster:
```bash
kind delete cluster --name $CLUSTER
```

# Provision in clouds

## AWS

## GCP

## DO

# References

* [Kind: Quck start](https://kind.sigs.k8s.io/docs/user/quick-start/)
* [Kubectl: install](https://kubernetes.io/docs/tasks/tools/install-kubectl-linux/)