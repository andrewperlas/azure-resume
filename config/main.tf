terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=3.0.0"
    }
  }
  backend "azurerm" {
    resource_group_name  = "crcdev-rg"
    storage_account_name = "apcrcdevstorage1"
    container_name       = "tfstate"
    key                  = "terraform.tfstate"
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
  name                     = "apcrcdevstorage1"
  resource_group_name      = azurerm_resource_group.crcdev-rg.name
  location                 = azurerm_resource_group.crcdev-rg.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
  static_website {
    index_document     = "index.html"
    error_404_document = "404.html"
  }
  tags = {
    environment = "dev"
  }
}

resource "azurerm_storage_container" "tfstate" {
  name                  = "tfstate"
  storage_account_name  = azurerm_storage_account.crcdev-storage.name
  container_access_type = "private"
}

resource "azurerm_cdn_profile" "crcdev-cdn-profile" {
  name                = "crcdevcdnprofile1"
  location            = "West US"
  resource_group_name = azurerm_resource_group.crcdev-rg.name
  sku                 = "Standard_Microsoft"
  tags = {
    environment = "dev"
  }
}

resource "azurerm_cdn_endpoint" "crcdev-cdn-endpoint" {
  name                = "crcdevcdnendpoint1"
  profile_name        = azurerm_cdn_profile.crcdev-cdn-profile.name
  location            = azurerm_cdn_profile.crcdev-cdn-profile.location
  resource_group_name = azurerm_resource_group.crcdev-rg.name
  origin_host_header  = "apcrcdevstorage1.z5.web.core.windows.net"
  origin {
    name      = "devresume"
    host_name = "apcrcdevstorage1.z5.web.core.windows.net"
  }
  tags = {
    environment = "dev"
  }
}

resource "azurerm_cdn_endpoint_custom_domain" "devresume" {
  name            = "devresume-andrewperlas-com"
  cdn_endpoint_id = azurerm_cdn_endpoint.crcdev-cdn-endpoint.id
  host_name       = "devresume.andrewperlas.com"
  cdn_managed_https {
    certificate_type = "Dedicated"
    protocol_type    = "ServerNameIndication"
    tls_version      = "TLS12"
  }
}