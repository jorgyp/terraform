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


resource "azurerm_virtual_network" "example" {
  name                = "examplevnet"
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name
  address_space       = ["10.1.0.0/16"]
}

resource "azurerm_subnet" "example" {
  name                 = "examplesubnet"
  resource_group_name  = azurerm_resource_group.example.name
  virtual_network_name = azurerm_virtual_network.example.name
  address_prefix       = "10.1.0.0/24"

  delegation {
    name = "delegation"

    service_delegation {
      name    = "Microsoft.ContainerInstance/containerGroups"
      actions = ["Microsoft.Network/virtualNetworks/subnets/action"]
    }
  }
}

resource "azurerm_network_profile" "example" {
  name                = "examplenetprofile"
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name

  container_network_interface {
    name = "examplecnic"

    ip_configuration {
      name      = "exampleipconfig"
      subnet_id = azurerm_subnet.example.id
    }
  }
}

resource "azurerm_container_group" "example" {
  name                  = "eventconsumer"
  location              = azurerm_resource_group.example.location
  resource_group_name   = azurerm_resource_group.example.name
  ip_address_type       = "private"
  network_profile_id    = azurerm_network_profile.example.id
  os_type               = "linux"

  container {
    name   = "eventconsumersvc"
    image  = "syagolnikov/event-consumer-svc:1.0.1"
    cpu    = "1"
    memory = "2"
    ports {
      port     = 80
      protocol = "TCP"
    }

  secure_environment_variables = {
    "COSMOS_DB_ENDPOINT"  = azurerm_cosmosdb_account.db.name,".documents.azure.com"
    "COSMOS_DB_MASTERKEY" = azurerm_cosmosdb_account.db.primary_master_key
    "COSMOS_DB_USERNAME" = azurerm_cosmosdb_account.db.name
    }
  }
}