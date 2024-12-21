# Kubernetes the hardway in Azure
###### Jagan Lakshmipathy 
###### 12/21/2024

### 1. Introduction
In this repo we will work through the details on how to stand up and deploy Kuberenetes cluster the hard way in Azure. We mean the hardway to refer to a self managed cluster as opposed to managed clusters offered by major cloud providers like Azure, DigitalOcean, GCP and AWS. This repo was inspired by this tutorial [tutorial](https://github.com/ivanfioravanti/kubernetes-the-hard-way-on-azure/blob/master/README.md). Which inturn is a fork of the [Kubernetes The Hard Way](https://github.com/kelseyhightower/kubernetes-the-hard-way) tutorial by [Kelsey Hightower](https://x.com/i/flow/login?redirect_after_login=%2Fkelseyhightower). 

### 2. Following are the steps
We have provided 23 shell scripts which we will use in different parts of this deployment. This deployment will leverage the Azure and we will deploy 3 controller nodes to deploy kubernetes control plane components and 2 worker nodes run workloads and to deploy kublet components. Our scripts will be run either in a controller node, or a worker node or you local host where you run kubectl client to control the kubernetes from. 
#### 2.1 Create Compute Resources
#### 2.2 Create Certificates
#### 2.3 Create Kubenernetes Configurations for Internal Connections
#### 2.4 Create Encryption Configurations
#### 2.5 Bootstrap ETCDs
#### 2.6 Bootstrap Control Plane
#### 2.7 Setup LoadBalancer
#### 2.8 Verify Control Plane
#### 2.9 Bootstrap Kubelet Components
#### 2.10 Verify Controllers
#### 2.11 Create Kubernetes Configurations for Kuberenetes API
#### 2.12 Verify Nodes & Components
#### 2.13 Create Pod Routes
#### 2.14 Deploy & Verify CoreDNS