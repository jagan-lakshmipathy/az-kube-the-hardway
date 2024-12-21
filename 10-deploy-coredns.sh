#!/bin/zsh


kubectl apply -f coredns-1.8.yaml --kubeconfig=kubernetes-the-hard-way.kubeconfig
sleep 1
kubectl get pods -l k8s-app=kube-dns -n kube-system --kubeconfig=kubernetes-the-hard-way.kubeconfig


