provider "azurerm" {
  version = "=1.36.1"
}

terraform {
  backend "azurerm" {
    resource_group_name       = "${aksResourceGroupName}"
    storage_account_name      = "${storageAccountName}"
    container_name            = "${containerName}"
    key                       = "${key}"
  }
}


module "storage_container" {
    source                    = "${sourceStorageContainer}"
    storage_container_name    = "${storageContainerName}"
    storage_account_name      = "${storageAccountName}"
    container_access_type     = "${containerAccessType}"
}

module "aks" {
    source                    = "${source}"
    aks_k8s_version           = "${aksK8sVersion}"
    aks_location              = "${aksLocation}"
    aks_resource_group_name   = "${aksResourceGroupName}"
    aks_cluster_name          = "${aksClusterName}"
    aks_node_count            = "${aksNodeCount}"
    aks_dns_prefix            = "${aksDnsPrefix}"
    aks_admin_username        = "${aksAdminUsername}"
    azure_client_id           = "${azureClientId}"
    azure_client_secret       = "${azureClientSecret}"
}

output "kube_config_prod" {
  value = "${module.aks.kube_config}"
}


#Run: terraform output kube_config > ~/.kube/aksconfig && export KUBECONFIG=~/.kube/aksconfig