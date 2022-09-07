#!/bin/bash

set -ex

GITHUB_USER="mstrielnikov"
GITHUB_REPO="cucumbernetes"
GITHUB_BRANCH="master"
CLUSTER_PATH="./cluster"

flux bootstrap github \
  --owner=$GITHUB_USER \
  --repository=$GITHUB_REPO \
  --branch=$GITHUB_BRANCH \
  --path=$CLUSTER_PATH \
  --personal
  
exit 0;