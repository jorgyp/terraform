provider "azurerm" {
  # whilst the `version` attribute is optional, we recommend pinning to a given version of the Provider
  version = "2.0.0"
  features {}
}
module "resource_group" {
    source                    = "${sourceResourceGroup}"
    location                  = "${location}"
    resource_group_name       = "${resourceGroupName}"
}

module "storage_account" {
    source                    = "${sourceStorageACccount}"
    environment               = "${environment}"
    storage_account_name      = "${storageAccountName}"
    resource_group_name       = "${resourceGroupName}"
    location                  = "${location}"
    account_tier              = "${accountTier}"
    account_replication_type  = "${accountReplicationType}"
}

module "storage_container" {
    depends_on = ["null_resource.delay"]
    source                    = "${sourceStorageContainer}"
    storage_container_name    = "${storageContainerName}"
    storage_account_name      = "${storageAccountName}"
    container_access_type     = "${containerAccessType}"
}

resource "null_resource" "delay" {
  provisioner "local-exec" {
    command = "sleep 600"
  }
  triggers = {
    "before" = "${storage_container}"
  }
}
