provider "azurerm" {
  # whilst the `version` attribute is optional, we recommend pinning to a given version of the Provider
  version = "2.0.0"
  features {}
}

resource "azurerm_storage_container" "example" {
  name                  = "akscontainer"
  storage_account_name  = "aksaccountsyag"
  container_access_type = "private"
}
