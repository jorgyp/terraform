provider "azurerm" {
  version = "=1.36.1"
}

resource "azurerm_resource_group" {
  name                = var.resource_group_name
  location            = var.location
}

resource "azurerm_storage_account" {
  name                     = var.storage_account_name
  resource_group_name      = azurerm_resource_group.name
  location                 = azurerm_resource_group.location
  account_tier             = var.account_tier
  account_replication_type = var.account_replication_type

  tags = {
    environment = "production"
  }
}

resource "azure_storage_container" "stor-cont" {
  name                  = var.storage_container_name
  container_access_type = var.storage_container_type
  storage_service_name  = var.storage_container_service_name
}


