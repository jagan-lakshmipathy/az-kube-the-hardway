# Kubernetes the hard way in Azure
###### Jagan Lakshmipathy 
###### 12/21/2024

### 1. Introduction
In this repo we will work through the details on how to stand up and deploy Kuberenetes cluster the hard way in Azure. We mean the hard way to refer to a self managed cluster as opposed to managed clusters offered by major cloud providers like Azure, DigitalOcean, GCP and AWS. This repo was inspired by this [tutorial](https://github.com/ivanfioravanti/kubernetes-the-hard-way-on-azure/blob/master/README.md), which in turn is a fork of the [Kubernetes The Hard Way](https://github.com/kelseyhightower/kubernetes-the-hard-way) tutorial by [Kelsey Hightower](https://x.com/i/flow/login?redirect_after_login=%2Fkelseyhightower). 

### 2. Step-by-step Approach to the Self-managed Kubernetes Cluster
This repo contains 23 shell scripts which we will use in different parts of this deployment. This deployment will leverage the Azure and we will deploy 3 controller nodes to deploy kubernetes control plane components and 2 worker nodes run workloads and to deploy kublet components. However, this can be extended to any number of controllers and workers. Our scripts will be run either in a controller node, or a worker node or your local host where you run kubectl client to control the kubernetes from. Before we get started, let's login to your azure account from your local host. Of the 23 shell scripts, two of them are scripts that will help the user to remote copy and login to the Azure nodes. In our case, we will use it to copy files from local host to controller nodes or worker nodes. 
```
    remote-login controller-0  #this will command will let you login to controller-0 node in the Azure cluster
    remote-copy controller-0 a.txt  # this command will remote copy the local file a.txt to the controller-o node in the Azure cluster

```
#### 2.1 Create Compute Resources
At this step, we will create a azure cluster as shown in this diagram below. We need to be aware of 3 CIDR ranges: (1) Azure VNET 10.240.0.0/24, (2) Kubernetes Cluster IP 10.32.0.0/24, and (3) POD CIDR 10.200.0.0/16. Two of the 3 CIDR ranges listed above, (1) and (3) are shown in the diagram below. They refer to the VNET and POD CIDR ranges. The (2) CIDR range is shown in the diagram below but they are listed in the 02-certificate-authority.sh, 06-bootstrapping-cp.sh, and 07-bootstrapping-kubelet.sh. We will walk through them detail as we run those scripts. Script in 01-compute-resources.sh will create the network shown in the diagram below. We will run in this in our local host. As we are running this list in MacOS and zsh.

![image](./azure_network.png)


#### 2.2 Create Certificates
At this step, we will run 02-certificate-authority.sh. This script will create admin, ca kubeernetes, service-account, kube-controller-manager, kube-scheduler, worker-0, and worker-1 certificates. In the end, we will copy ca.pem, kubernetes.pem, kubernetes-key.pem, worker-0.pem, and worker-1.pem to the worker nodes. It is worth noting the difference between the ivan's repo and this repo that kubernetes hostname parameter includes the worker node ips in line 240. In this repo, we are planning to use the Calico CNI. Calico need to connect to ETCD nodes in control plane. 
#### 2.3 Create Kubenernetes Configurations for Internal Connections
At this step, we will run 03-kube-configurations.sh. This script we will generate 6 *.kubeconfig files. These files are used to connect to internal kubernetes components to connect to eeach other. As the name of the files suggest, they enable that specific component. Example, kube-proxy.kubeconfig, file enable connecting to kube-proxy component using kubectl. Similarly, admin.kubeconfig enable you to connect to the Kubernetes API server as a admin user.

#### 2.4 Create Encryption Configurations
At this step we will run the 04-encryption-configuration.sh. This script will create an encryption configuration file and upload this to controller hosts. This encryption file will used when deploying the kube-apiserver. This will help to keep the file or any data at rest encrypted. 

#### 2.5 Bootstrap ETCDs
In this step, we will remote copy the 05-bootstrapping-etcd.sh to each controller nodes (in our case 3 controllers). And then we remote login to each controller node to run this script from that node. It is imperitive to start them simulataneously as much as possible in all the nodes. As each instance of ETCD will look for its counterpart in the other controllers. Make sure to file mode to executable using the 'chmod' command. At the end of the script, you will see "Verified etcd instance" on the console, that verifies each instance had verified the other two instance running on the controllers.

#### 2.6 Bootstrap Control Plane
At this step, first we will copy 06-bootstrapping-cp.sh, and 06-setup-kubernetes-authorization.sh to each controller nodes. Note the --service-cluster-ip-range flags at line 74 and 106. They have to match and they refer to the clusterIP service range. Also, note the kube controller manager options cluster-cidr=10.200.0.0/16 --allocate-node-cidrs=true. They together enable CIDR range for the POD virtual device that are created. At the end you the bootstrapping script will list the running components that will list 3 etcd components one each on the controller and scheduler and controller-manager components.The authorization setup script will create a clusterRole and roleBinding for kubernetes users. So, run  06-bootstrapping-cp.sh, and 06-setup-kubernetes-authorization.sh in that order in each controller. 

Now, run 06-setup-frontend-lb.sh and 06-verify-controller.sh locally in that order. The frontend-lb script will create the LB and verify script will mruncurl command with a sample payload to verify the kubernetes version. 

#### 2.7 Bootstrap Kubelet Components
Now that, we have setup the Control Plane, lets setup the Worker Nodes. Bootstrapping kubelet is the central piece in the worker node setup. Note, we added kubernetes.pem and kubernetes-key.pem files to /usr/lib/kubernetes directory at line 124. We used these files when configuring the kublet.
#### 2.10 Verify Controllers
#### 2.11 Create Kubernetes Configurations for Kuberenetes API
#### 2.12 Verify Nodes & Components
#### 2.13 Create Pod Routes
#### 2.14 Deploy & Verify CoreDNS