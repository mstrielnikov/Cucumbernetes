#!/bin/bash

set -ex

export KUBECONFIG="${HOME}/.kube/kind/cucumbernetes"

kind create cluster --name cucumbernetes --kubeconfig ${KUBECONFIG}

exit 0;