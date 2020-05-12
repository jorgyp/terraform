terraform {
  backend "azurerm" {
    resource_group_name       = "tfgroupyagolnikov"
    storage_account_name      = "tfstorageyagolnikov"
    container_name            = "terraformrg"
    key                       = "tfstateprod"
  }
}

module "aks" {
    source                    = "${source}"
    aks_k8s_version           = "${aksK8sVersion}"
    aks_location              = "${aksLocation}"
    aks_resource_group_name   = "${aksResourceGroupName}"
    aks_cluster_name          = "${aksClusterName}"
    aks_node_count            = "${aksNodeCount}"
    aks_dns_prefix            = "${aks_dns_prefix}"
    aks_admin_username        = "${aks_admin_username}"
    aks_client_id             = "${aks_client_id}"
    aks_client_secret         = "${aks_client_secret}"
}

output "kube_config_prod" {
  value = "${module.aks.kube_config}"
}

#Run: terraform output kube_config > ~/.kube/aksconfig && export KUBECONFIG=~/.kube/aksconfig