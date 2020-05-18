## Reusable Terraform

> This repo provides an approach to performing multi-environment infrastructure provisioning by  using reusable Terraform modules in the context of a kubernetes centric infrastructure. 

## Table of Contents

- [Prerequisites](#prerequisites)
- [Usecase](#usecase)
- [Folder_structure](#folder_structure)
- [First_launch](#first_launch)
- [Reuse_code](#reuse_code)
- [Azure_pipelines](#azure_pipelines)
- [GitOps_flux](#gitops_flux)

## Prerequisites
>
- Azure account 
- Azure cli (locally)
- Terraform 1.12.0+
- Helm 3+
- Azure account with subscription
- Permissions to create resources under subscription
- AzureDevops for pipeline deployment

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

## Azure_pipelines  
><b>Background:</b> Azure-pipelines.yml live along side the manifest main.tf file located in deployments/$(environment)/infrastructure_component. Azure-pipeline.yml's inject the variables into the manifest file during the build proccess instead of hard-coding the values into manifest files itself. 

## GitOps_flux

><b>Background:</b> Launch infrastructure, config management, and k8s deployments by utilizing pull technology tools (terradiff, kubediff, and ansiblediff) instead of push code to cluster. To learn why this is a cool check out: <url> https://www.weave.works/technologies/gitops/ </url><br>

><b>Scenario:</b> AKS cluster is running, you don't want to manage the Continuos Deployment work and would like to take advantage of GitOps. 

1. Change into the scripts directory and run "bash gitops_deploy.sh" to install Weave's GitOps operator called Flux on the cluster. 
2. Follow bash instructions to validate gitops "git push" works as expected by using the test_api repository as a test app. 

Full instructions here: https://eksworkshop.com/weave_flux/

><b>Scenario:</b> You don't want to manually run scripts to deploy flux and want to officially deploy fluxcd via AzureDevops.

1. Create a new pipeline within Azure Devops.
2. Create Library called adoCredentials in AzureDevops and add variables ARM_CLIENT_ID, ARM_CLIENT_SECRET, ARM_SUBSCRIPTION_ID, ARM_TENANT_ID with values. Resourece: https://docs.microsoft.com/en-us/azure/developer/terraform/install-configure You can also store adoCredential values in azure vault and call them via azure pipeline Library.
3. Point new pipeline to flux pipeline: pipelines/flux-pipelines.yml
4. Make sure that you change the "gitRepo" value in pipelines/flux-pipelines.yml to your git repo.
5. After completing the deployment of flux via AzureDevops, copy the public RSA key (displayed in "RSA key" pipeline step) to your app's repository ( settings > Deploy keys > Add deploy key ) with write access.

Note: Flux checks changes in docker registry if there is a change it pushes commit to github that change has be noticed and reconciliation of k8s state and latest docker image occurs. 
