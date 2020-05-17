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
    environment            = var.environment
  }
}

resource "null_resource" "delay" {
  provisioner "local-exec" {
    command = "sleep 1000"
  }
}

resource "azurerm_storage_container" "example" {
  name                  = var.storage_container_name
  storage_account_name  = azurerm_storage_account.store.name
  container_access_type = var.container_access_type
}

