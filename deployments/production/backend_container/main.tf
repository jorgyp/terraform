provider "azurerm" {
  # whilst the `version` attribute is optional, we recommend pinning to a given version of the Provider
  version = "2.0.0"
  features {}
}

module "storage_container" {
    source                    = "${sourceStorageContainer}"
    storage_container_name    = "${storageContainerName}"
    storage_account_name      = "${storageAccountName}"
    container_access_type     = "${containerAccessType}"
}
