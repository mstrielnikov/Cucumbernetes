#!/usr/bin/sh

set -xe

# Install Flux v2 CLI

FLUXCD_CLI_URL="https://fluxcd.io/install.sh"

curl -s "${FLUXCD_CLI_URL}" | sudo bash

if [[ $? -ne 0 ]]
then
    >&2 echo "Fluxcd v2 CLI failed to install"
fi

if ! flux check --pre
then 
    >&2 echo "Fluxcd v2 CLI failed to run"
fi

# Install Linkerd CLI

LINKERD_DIR="$HOME/.linkerd2/bin"

if [[ ! -d "${LINKERD_DIR}" ]]
then 
    if [[ mkdir "${LINKERD_DIR}" | false ]]
    then 
        >&2 echo "Unable to create ${LINKERD_DIR}"
        exit -1; 
    else
        curl --proto '=https' --tlsv1.2 -sSfL "${LINKERD_URL}" | sh
    fi
fi

export PATH="$PATH:$LINKERD_DIR"

linkerd version

linkerd check

linkerd viz check

# linkerd jaeger check

# Install Vault CLI 

VAULT_REPO="https://github.com/hashicorp/vault.git"

mkdir -p "$GOPATH/src/github.com/hashicorp" && cd "$_"

git clone "${VAULT_REPO}"

cd vault

make bootstrap

make dev

exit 0;