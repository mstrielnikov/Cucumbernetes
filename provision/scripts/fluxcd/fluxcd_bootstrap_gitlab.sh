#!/bin/bash

set -ex

GITLAB_USER="mstrielnikov"
GITLAB_REPO="cucumbernetes"
GITLAB_BRANCH="main"
CLUSTER_PATH="./cluster"


if [[ -z "$GITLAB_TOKEN" ]]
then 
  >&2 echo "GITLAB_TOKEN is unexported"
  exit -1;
fi


flux bootstrap gitlab \
  --owner=$GITLAB_USER \
  --repository=$GITLAB_REPO \
  --branch=$GITLAB_BRANCH \
  --path=$CLUSTER_PATH
  --token-auth
  
exit 0;