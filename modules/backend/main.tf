provider "azurerm" {
  # whilst the `version` attribute is optional, we recommend pinning to a given version of the Provider
  version = "2.0.0"
  features {}
}

resource "azurerm_storage_blob" "aks" {
  name                   = var.blob_name
  storage_account_name   = "aksaccountsyag"
  storage_container_name = var.storage_container_name
  type                   = var.blob_type
}