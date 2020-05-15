provider "azurerm" {
  # whilst the `version` attribute is optional, we recommend pinning to a given version of the Provider
  version = "2.0.0"
  features {}
}

resource "azurerm_resource_group" "store" {
  name                = var.resource_group_name
  location            = var.location
}

resource "azurerm_storage_account" "store" {
  name                     = var.storage_account_name
  resource_group_name      = azurerm_resource_group.store.name
  location                 = azurerm_resource_group.store.location
  account_tier             = var.account_tier
  account_replication_type = var.account_replication_type

  tags = {
    environment = "production"
  }
}

resource "azure_storage_container" "stor-cont" {
  name                  = var.storage_container_name
  container_access_type = var.storage_type
  storage_service_name  = var.storage_service
}

resource "azurerm_storage_blob" "aks" {
  name                   = var.blob_name
  storage_account_name   = azurerm_storage_account.store.name
  storage_container_name = azure_storage_container.stor-cont.name
  type                   = var.blob_type
}