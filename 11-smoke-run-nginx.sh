#!/bin/zsh

kubectl create deployment nginx --image=nginx --kubeconfig=kubernetes-the-hard-way.kubeconfig
kubectl get pods -l app=nginx --kubeconfig=kubernetes-the-hard-way.kubeconfig


echo "Started nginx in a Pod"
echo "Now forward the port to your host."
POD_NAME=$(kubectl get pods -l app=nginx --kubeconfig=kubernetes-the-hard-way.kubeconfig -o jsonpath="{.items[0].metadata.name}")
#kubectl port-forward --kubeconfig=kubernetes-the-hard-way.kubeconfig  $POD_NAME 8080:80