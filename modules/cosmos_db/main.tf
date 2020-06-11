provider "azurerm" {
  version = "=2.0.0"
  features {}
}

resource "azurerm_resource_group" "example" {
  name                  = "cosmosdbgroup"
  location              = "westus2"
}

resource "azurerm_cosmosdb_account" "db" {
  name                = "events-database"
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name
  offer_type          = "Standard"
  kind                = "MongoDB"
  enable_automatic_failover = false

  consistency_policy {
    consistency_level       = "BoundedStaleness"
    max_interval_in_seconds = 10
    max_staleness_prefix    = 200
  }

  geo_location {
    prefix            = "cosmos-db-customid"
    location          = azurerm_resource_group.example.location
    failover_priority = 0
  }
}