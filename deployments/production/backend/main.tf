module "resource_group" {
    source                    = "${sourceResourceGroup}"
    location                  = "${location}"
    resource_group_name       = "${resourceGroupName}"
}

module "storage_account" {
    source                    = "${sourceStorageACccount}"
    evironment                = "${environment}"
    storage_account_name      = "${storageAccountName}"
    resource_group_name       = "${resourceGroupName}"
    location                  = "${location}"
    account_tier              = "${accountTier}"
    account_replication_type  = "${accountReplicationType}"
}

module "storage_container" {
    source                    = "${sourceStorageContainer}"
    storage_container_name    = "${storageContainerName}"
    container_access_type     = "${containerAccessType}"
}