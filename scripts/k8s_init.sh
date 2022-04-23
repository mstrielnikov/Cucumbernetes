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

linkerd jaeger install | kubectl apply -f -

linkerd jaeger check

# Install Vault 

VAUL_REPO_HELM="https://helm.releases.hashicorp.com"

VAULT_OVERRIDE_CONFIG="../k8s/vault/override-values.yaml"

kubectl create namespace vault

helm repo add hashicorp "${VAUL_REPO_HELM}"

helm search repo hashicorp/vault

helm install vault hashicorp/vault \
    --namespace vault \
    -f "${VAULT_OVERRIDE_CONFIG}"

# Install Victoria Metrics

VM_REPO_HELM="https://victoriametrics.github.io/helm-charts/"

helm repo add vm "${VM_REPO_HELM}"

helm repo update

helm search repo vm/

cat <<EOF | helm install vmcluster vm/victoria-metrics-cluster -f -
vmselect:
  podAnnotations:
      prometheus.io/scrape: "true"
      prometheus.io/port: "8481"

vminsert:
  podAnnotations:
      prometheus.io/scrape: "true"
      prometheus.io/port: "8480"

vmstorage:
  podAnnotations:
      prometheus.io/scrape: "true"
      prometheus.io/port: "8482"
EOF

# Install vmagent

VM_AGENT_HELM_REPO="https://docs.victoriametrics.com/guides/guide-vmcluster-vmagent-values.yaml"

helm install vmagent vm/victoria-metrics-agent -f "${VM_AGENT_HELM_REPO}"

helm repo update

# Install Grafana

GRAFANA_HELM_REPO="https://grafana.github.io/helm-charts"

helm repo add grafana 

helm repo update

cat <<EOF | helm install my-grafana grafana/grafana -f -
  datasources:
    datasources.yaml:
      apiVersion: 1
      datasources:
        - name: victoriametrics
          type: prometheus
          orgId: 1
          url: http://vmcluster-victoria-metrics-cluster-vmselect.default.svc.cluster.local:8481/select/0/prometheus/
          access: proxy
          isDefault: true
          updateIntervalSeconds: 10
          editable: true

  dashboardProviders:
   dashboardproviders.yaml:
     apiVersion: 1
     providers:
     - name: 'default'
       orgId: 1
       folder: ''
       type: file
       disableDeletion: true
       editable: true
       options:
         path: /var/lib/grafana/dashboards/default

  dashboards:
    default:
      victoriametrics:
        gnetId: 11176
        revision: 18
        datasource: victoriametrics
      vmagent:
        gnetId: 12683
        revision: 7
        datasource: victoriametrics
      kubernetes:
        gnetId: 14205
        revision: 1
        datasource: victoriametrics
EOF

exit 0;