#!/bin/zsh

for instance in worker-0 worker-1; do
  PRIVATE_IP_ADDRESS=$(az vm show -d -g kubernetes -n ${instance} --query "privateIps" -otsv)
  POD_CIDR=$(az vm show -g kubernetes --name ${instance} --query "tags" -o tsv)
  echo $PRIVATE_IP_ADDRESS $POD_CIDR
done