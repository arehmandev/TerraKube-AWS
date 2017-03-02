# TerraKube - Formerly Prototype-X

This repo is currently being tested and cleaned up.

Welcome to Terrakube, a project of mine brought from persional passion and frustration with current Kubernetes offerings on AWS.

This repo is designed to equip you with everything you require to provision a Highly Available Kubernetes Cluster on AWS.

To use:
```
1. Install Terraform, jq and AWS cli.
2. Clone this repo and run the commands below
3. terraform fmt && terraform get && terraform plan
4. terraform apply
5. bash Scripts/cluster-test.sh - this will notify you once the cluster ready"
6. Now wait, and once the clusters ready, "kubectl get nodes" can be run
7. kubectl apply -f Addons
8. bash Scripts/dashboard.sh - brings up the kubernetes dashboard via kube proxy
```

Todo:

- The above will be made into a nice Makefile once some final adjustments have been made 
- Document how each module works and the general structure
- Clean up the variables, and add optional cool lambda, OpenVPN and other addon modules.


To run a quick demo run:

kubectl apply -f Kubedemo/Traefik-demo

This will be further documented later.

-------------------------

Plan for dev:

1. Etcd - smilodon ENI creation *complete*

2. Etcd - smilodon EBS creation *complete*

3. Etcd - data Template *complete*

4. Kube master completion of static pods *complete*

5. with ELB attachment *complete*

6. Kube admin local exec module *complete* (can now do kubectl get nodes)

7. Kube node seperate module *in progress - complete*

8. Addons included *complete* - optional, create makefile

Kubernetes setup complete - undergoing QA and testing


----------------------

Inspiration:

UKHomeOffice/smilodon
kz8s/tack
gambol99/kmsctl
vaijab
CoreOS official documentation
