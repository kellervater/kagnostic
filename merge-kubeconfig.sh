#!/bin/bash

cd $(dirname "$0")
if [ -z $1 ]; then echo -e "\033[0;31mPlease specify cluster name! You can choose one of these: \033[0;0m" && $(basename "ls *kubeconfig") && echo "choose wisely..." && exit 1; else echo "using ${1%.*} as clusterconfig."; fi
ORIGINAL_KUBECONFIG=$(basename "$1")
if ! test -f $ORIGINAL_KUBECONFIG ; then
    echo "No file $ORIGINAL_KUBECONFIG found. please run ansible/bootstrap-k8s.sh first. Exiting..."
    exit 1
fi

KUBECONTEXT_NAME=${ORIGINAL_KUBECONFIG%%.*}
echo "new kubecontext to merge: $KUBECONTEXT_NAME"

# Now the merger
# 1st: create/overwrite a backup
echo "backing up old config.."
cp ~/.kube/config ~/.kube/config.bak 
# 2nd: merge configs
set +e
echo "Deleting possibly preexisting config from this cluster... IGNORE errors here for now"
kubectl config delete-user kube-admin-$KUBECONTEXT_NAME 
kubectl config delete-context $KUBECONTEXT_NAME
kubectl config delete-cluster $KUBECONTEXT_NAME
set -e
# this is the magic trick to merge 2 kubeconfigs
KUBECONFIG=~/.kube/config:$ORIGINAL_KUBECONFIG kubectl config view --flatten > .kubeconfig_merged
# 3rd: replace config
mv .kubeconfig_merged ~/.kube/config

#use new context
kubectl config use-context $KUBECONTEXT_NAME
kubectl get nodes
