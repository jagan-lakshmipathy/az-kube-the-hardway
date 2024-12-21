#!/bin/zsh

#verification
kubectl run busybox --image=busybox:1.28 --command --kubeconfig=kubernetes-the-hard-way.kubeconfig -- sleep 3600
kubectl get pods -l run=busybox --kubeconfig=kubernetes-the-hard-way.kubeconfig

POD_NAME=$(kubectl get pods -l run=busybox --kubeconfig=kubernetes-the-hard-way.kubeconfig -o jsonpath="{.items[0].metadata.name}")
kubectl exec -ti $POD_NAME --kubeconfig=kubernetes-the-hard-way.kubeconfig -- nslookup kubernetes


#If this verification fail then try debugging the core-dns deployment by following the instructions in the following link:
# https://kubernetes.io/docs/tasks/administer-cluster/dns-debugging-resolution/#check-the-local-dns-configuration-first