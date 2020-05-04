terraform {
  backend "azurerm" {
    resource_group_name       = "tfgroupyagolnikov"
    storage_account_name      = "tfstorageyagolnikov"
    container_name            = "terraformrg"
    key                       = "tfstateprod"
  }
}

module "aks" {
    source                    = "../../modules/aks/"
    aks_k8s_version           = "1.16.7"
    aks_location              = "West US 2"
    aks_resource_group_name   = "aks-production-manage-rg"
    aks_cluster_name          = "aks-production-manage"
    aks_node_count            = 2
    aks_dns_prefix            = "aks-production"
    aks_admin_username        = "sergeyago"
    aks_client_id             = "clientId"
    aks_client_secret         = "clientSecret"
}

output "kube_config_prod" {
  value = "${module.aks.kube_config}"
}

#Run: terraform output kube_config > ~/.kube/aksconfig && export KUBECONFIG=~/.kube/aksconfig