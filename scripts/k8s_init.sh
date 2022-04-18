#!/usr/bin/sh

set -xe

if [[ -z ${USER} ]]
then
    >&2 echo "USER variable is not set"
    exit -1;
fi

if [[ -z ${PATH} ]]
then
    >&2 echo "PATH variable is not set"
    exit -1;
fi

if [[ -z ${KUBECONFIG} ]]
then 
    >&2 echo "KUBECONFIG variable is not set"
    exit -1;
fi

if [[ ! -f "${KUBECONFIG}" ]]
then 
    >&2 echo "Context file path ${KUBECONFIG} is empty or not available"
    exit -1; 
fi

# Install full ArgoCD 

ARGOCD_URL="https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml"

kubectl create namespace argocd

kubectl apply -n argocd -f "${ARGOCD_URL}"

# Install Linkerd with extensions

LINKERD_URL="https://run.linkerd.io/install"check in pipe if non zero

curl --proto '=https' --tlsv1.2 -sSfL "${LINKERD_URL}" | sh

if [[ ! -d "$HOME/.linkerd2/bin" ]]
then 
    >&2 echo "Directory path $HOME/.linkerd2/bin/ does not exist or not available"
    exit -1; 
fi

export PATH="$PATH:$HOME/.linkerd2/bin"

linkerd version

linkerd check --pre

linkerd install | kubectl apply -f -

linkerd check

linkerd viz install | kubectl apply -f -

linkerd viz check

# Install Vault 

VAUL_REPO_HELM="https://helm.releases.hashicorp.com"

VAULT_OVERRIDE_CONFIG="../k8s/vault/override-values.yaml"

kubectl create namespace vault

helm repo add hashicorp "${VAUL_REPO_HELM}"

helm search repo hashicorp/vault

helm install vault hashicorp/vault \
    --namespace vault \
    -f "${VAULT_OVERRIDE_CONFIG}"

exit 0;