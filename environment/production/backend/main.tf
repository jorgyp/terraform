module "backend" {
    source                    = "../../../modules/backend"
    resource_group_name       = "aksrg"
    location                  = "West US 2"
    storage_account_name      = "aksaccountsyag"
    account_tier              = "Standard"
    account_replication_type  = "LRS"
    storage_container_name    = "akscontainer"
    storage_service           = "aksstorageservice"
    blob_name                 = "aksblobsyag"
    blob_type                 = "Block"
    storage_type              = "blob"
}
