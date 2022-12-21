#!/bin/sh
# Installs all pms migration utility charts
## Usage: ./install.sh [kubeconfig]

if [ $# -ge 1 ] ; then
  export KUBECONFIG=$1
fi

NS=upgrade
CHART_VERSION=12.0.2

echo Create $NS namespace
kubectl create ns $NS

echo Istio label
kubectl label ns $NS istio-injection=enabled --overwrite
helm repo update

echo Copy configmaps
./copy_cm.sh

echo Installing partner manager
helm -n $NS install pms-migration-utility mosip/pms-migration-utility --wait --wait-for-jobs --version $CHART_VERSION

kubectl -n $NS  get deploy -o name |  xargs -n1 -t  kubectl -n $NS rollout status

echo Installed pms-migration-utility services

