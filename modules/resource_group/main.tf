provider "azurerm" {
  # whilst the `version` attribute is optional, we recommend pinning to a given version of the Provider
  version = "2.0.0"
  features {}
}

resource "azurerm_resource_group" "store" {
  name                = var.resource_group_name
  location            = var.location
}