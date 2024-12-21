#!/bin/zsh



kubectl logs $POD_NAME  --kubeconfig=kubernetes-the-hard-way.kubeconfig 

kubectl exec -ti $POD_NAME  --kubeconfig=kubernetes-the-hard-way.kubeconfig  -- nginx -v

kubectl expose deployment nginx --port 80 --type NodePort  --kubeconfig=kubernetes-the-hard-way.kubeconfig 

echo "The LoadBalancer service type can not be used because your cluster is not configured with cloud provider integration. Setting up cloud provider integration is out of scope for this tutorial."
kubectl expose deployment nginx --port 80 --type NodePort  --kubeconfig=kubernetes-the-hard-way.kubeconfig 


NODE_PORT=$(kubectl get svc nginx  --kubeconfig=kubernetes-the-hard-way.kubeconfig \
  --output=jsonpath='{range .spec.ports[0]}{.nodePort}')



az network nsg rule create -g kubernetes \
  -n kubernetes-allow-nginx \
  --access allow \
  --destination-address-prefix '*' \
  --destination-port-range ${NODE_PORT} \
  --direction inbound \
  --nsg-name kubernetes-nsg \
  --protocol tcp \
  --source-address-prefix '*' \
  --source-port-range '*' \
  --priority 1002

echo "Added NSG ruple to allow remote access to ngixn pod"

EXTERNAL_IP=$(az network public-ip show -g kubernetes \
  -n worker-0-pip --query "ipAddress" -otsv)



curl -I http://$EXTERNAL_IP:$NODE_PORT 
echo "Check the output from nginx."