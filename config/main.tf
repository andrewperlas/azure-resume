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

resource "azurerm_resource_group" "crcdev-rg" {
  name     = "crcdev-rg"
  location = "West US 2"
  tags = {
    environment = "dev"
  }
}