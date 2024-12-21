#!/bin/zsh

kubectl get componentstatuses --kubeconfig=kubernetes-the-hard-way.kubeconfig
echo "01-listed componentes."

kubectl get nodes --kubeconfig=kubernetes-the-hard-way.kubeconfig
echo "02-listed nodes."