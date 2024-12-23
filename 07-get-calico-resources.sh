
curl -L  https://github.com/projectcalico/cni-plugin/releases/download/v3.20.6/calico-ipam-amd64 -o ./calico-ipam
curl -L  https://github.com/projectcalico/cni-plugin/releases/download/v3.20.6/calico-amd64 -o ./calico
ls -al calico*
echo '01-Downloaded Calico Binaries.'


chmod 711 calco*
ls -al calico*
echo '02-Set the execute mode.'



ETCD_IP="https://10.240.0.10:2379,"https://10.240.0.11:2379,"https://10.240.0.12:2379"
echo '03-ETCD_IP -> '${ETCD_IP}

cat > 10-calico.conf <<EOF
{
  "name": "calico",
  "type": "calico",
  "etcd_endpoints": "https://${ETCD_IP}:2379",
  "etcd_key_file": "/var/lib/kubernetes/kubernetes-key.pem",
  "etcd_cert_file": "/var/lib/kubernetes/kubernetes.pem",
  "etcd_ca_cert_file": "/var/lib/kubernetes/ca.pem",
  "log_level": "info",
  "ipam": {
    "type": "calico-ipam"
  },
  "policy": {
    "type": "calico"
  },
  "ipam": {
    "type": "calico-ipam",
    "subnet": "usePodCidr"
  }
}
EOF
ls -al 10-calico.conf
echo 'Created 10-calico.conf'


for instance in worker-0 worker-1; do
  PUBLIC_IP_ADDRESS=$(az network public-ip show -g kubernetes \
    -n ${instance}-pip --query "ipAddress" -o tsv)

  scp -o StrictHostKeyChecking=no calico-ipam calico 10-calico.conf ${instance}.pem kuberoot@${PUBLIC_IP_ADDRESS}:~/
done
echo 'Copied Calico Resources to Worker Nodes.'
