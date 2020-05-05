## Reusable Terraform

> This repo provides an approach to performing multi-environment infrastructure provisioning by  using reusable Terraform modules.

## Table of Contents

- [Prerequisites](#prerequisites)
- [Usecase](#usecase)
- [Folder_structure](#folder_structure)
- [First_launch](#first_launch)
- [Reuse_code](#Reuse_code)
- [GitOps](#gitops)

## Prerequisites
>
- Azure cli
- Terraform 1.12.0+
- Helm 3+ on workstation

## Usecase

>
- deploy infrastucture in Azure cloud declaratively
- maintain a balance of not repeating unnecessary code but also avoid overcomplicating deploy templates due to extreme modularity.
- deploy and manage multiple environments from same repository
- ensure identical mirroring of infrastructure between regardless of environments


## Folder_structure  

<pre>
|-- environment
|   |-- develop
|   |   `-- dev_aks_large_cluster
|   |-- production
|   |   `-- prod_aks_large_cluster
|   |      |
|   |       `-- main.tf
|   `-- stage
|   
|   
|-- modules
|   |-- aks
|   |   |-- main.tf
|   |   |-- outputs.tf
|   |   `-- variables.tf
|   `-- aks_experimental
`-- scripts
    `-- terraform_backend.sh
</pre>


<fieldset>
    <legend>Folder Legend</legend>
		- <u> environment/production/prod_aks_large_cluster:</u> folder that contains manifest file (main.tf) that allows for smallest unit of deployment for terraform infrastructure. <br>
		- <u>modules:</u> resusuable terraform modules which are invoked by the manifest file <br>
		- <u>modules/aks/main.tf</u> terraform module that is invoked by manifest <br>
		- <u>outputs.tf:</u> defines value/s that needs to be extracted during the terraform run (such as the kubeconfig value). <br>
		- <u>modules/aks/variables.tf:</u> variable declaration to be used in modules/aks/main.tf <br>
		- <u>scripts:</u> one time run scripts (like creating backend blob).
</fieldset>



## First_launch

><b>Scenario</b>: You need to deploy a AKS cluster and bravely decide to deploy to production first.

1. Install azure cli and run commands:
	<pre>$az login 
	$SUBSCRIPTION_ID=$(az account list | jq -r '.[] | select (.isDefault == true).id')
	$az ad sp create-for-rbac --role="Contributor" --scopes="/subscriptions/$SUBSCRIPTION_ID" | jq
	#appID is aksclientid and password is the aksclientsecret 
	</pre>
2. Change into scripts folder and run azure backend storage creation script <br>
<pre>$ terraform_backend.sh <resource_group_name> <storage_acct_name> <blob_container_name> </pre>

3. After backend storage is created add the storage three values to the manifest file. Also copy id and secret from step 1 (above> 
4. Also, add the appropriate values to the manifest file. 
5. From the same manifest directory run: <br>
$ terraform init && terraform plan && terraform apply -auto-approve 



## Reuse_code 
><b>Scenario:</b> Previous steps walked through luanching AKS in production environment. Below are steps outlining how to mirror production environment into develop. 

1. Copy manifest from the environment/production/prod_aks_large_cluster folder into environment/develop/dev_aks_large_cluster 
2. Adjust the environment/develop/dev_aks_large_cluster/main.tf values to match your dev cluster (IMPORTANT NOTE: make sure the "key" value for tfstate is ALWAYS UNIQUE). 
3. terraform init && terraform plan && terraform apply -auto-approve

## GitOps

><b>Background:</b> Launch infrastructure, config management, and k8s deployments by utilizing pull technology tools (terradiff, kubediff, and ansiblediff) instead of push code to cluster. To learn why this is a cool check out: <url> https://www.weave.works/technologies/gitops/ </url><br>

><b>Scenario:</b> AKS cluster is running, you don't want to manage the Continuos Deployment work and would like to take advantage of GitOps. 

1. Change into the scripts directory and run "bash gitops_deploy.sh" to install GitOps operator called flux the cluster. 
2. Follow instructions to validate gitops "git push" functions as expected. 

Full instructions here: https://eksworkshop.com/weave_flux/


