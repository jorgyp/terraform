provider "azurerm" {
  # whilst the `version` attribute is optional, we recommend pinning to a given version of the Provider
  version = "2.0.0"
  features {}
}
module "backend_storage" {
    source                    = "${sourceBackendStorage}"
    location                  = "${location}"
    resource_group_name       = "${resourceGroupName}"
    environment               = "${environment}"
    storage_account_name      = "${storageAccountName}"
    account_tier              = "${accountTier}"
    account_replication_type  = "${accountReplicationType}"
    storage_container_name    = "${storageContainerName}"
    container_access_type     = "${containerAccessType}"
}
