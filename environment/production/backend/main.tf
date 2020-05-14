module "backend" {
    resource_group_name       = "${resourceGroupName}"
    location                  = "${location}"
    storage_account_name      = "${storageAccountName}"
    account_tier              = "${accountTier}"
    account_replication_type  = "${accountReplicationType}"
    storage_container         = "${storageContainer}"
    storage_container_name    = "${storageContainerName}"
    storage_container_type    = "${storageContainerType}"
}
