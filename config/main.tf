terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=3.0.0"
    }
  }
}

provider "azurerm" {
  features {}
}

data "azurerm_subscription" "crcdev" {
  subscription_id = "e0a05e3d-c7c8-4da3-bb86-62e0f43a09ab"
}

resource "azurerm_resource_group" "crcdev-rg" {
  name     = "crcdev-rg"
  location = "West US 2"
  tags = {
    environment = "dev"
  }
}

resource "azurerm_storage_account" "crcdev-storage" {
  name                      = "apcrcdevstorage1"
  resource_group_name       = azurerm_resource_group.crcdev-rg.name
  location                  = azurerm_resource_group.crcdev-rg.location
  account_tier              = "Standard"
  account_replication_type  = "LRS"
  static_website {
    index_document = "index.html"
    error_404_document = "404.html"
  }
  tags = {
    environment = "dev"
  }
}