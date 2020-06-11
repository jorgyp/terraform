provider "azurerm" {
  version = "=1.36.1"
}

  terraform {
    backend "azurerm" {
      resource_group_name       = "aksrg"
      storage_account_name      = "aksaccountsyag"
      container_name            = "statecontainer"
      key                       = "aksprod"
    }
  }

module "aks" {
    source                    = "${source}"
    environment               = "${environment}"
    aks_k8s_version           = "${aksK8sVersion}"
    aks_location              = "${aksLocation}"
    aks_cluster_name          = "${aksClusterName}"
    aks_node_count            = "${aksNodeCount}"
    aks_dns_prefix            = "${aksDnsPrefix}"
    aks_admin_username        = "${aksAdminUsername}"
    azure_client_id           = "${azureClientId}"
    azure_client_secret       = "${azureClientSecret}"
    aks_resource_group_name   = "${aksResourceGroupName}"
}

output "kube_config_prod" {
  value = "${module.aks.kube_config}"
}


#Run: terraform output kube_config > ~/.kube/aksconfig && export KUBECONFIG=~/.kube/aksconfig