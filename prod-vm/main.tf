# prod-vm — the production-hardened sibling of ../lab-vm.
# Same "one apply rebuilds an identical box" idea, but with the controls a real
# environment expects: NO public IP on the VM (you reach it through Azure Bastion),
# Trusted Launch (secure boot + vTPM), encryption at host, a managed identity,
# auto-shutdown, and an optional remote-state backend.
#
# COST NOTE: Azure Bastion (Standard) and its Standard public IP bill hourly.
# This is not a leave-it-running lab. `make down` when you're finished.

terraform {
  required_version = ">= 1.5"
  required_providers {
    azurerm = { source = "hashicorp/azurerm", version = "~> 3.0" }
  }

  # --- Remote state (best practice on any team) -------------------------------
  # Create the storage account once (see README "Remote state"), then uncomment:
  # backend "azurerm" {
  #   resource_group_name  = "rg-tfstate"
  #   storage_account_name = "sttfstate<unique>"
  #   container_name       = "tfstate"
  #   key                  = "prod-vm.tfstate"
  # }
}

provider "azurerm" {
  features {}
}

locals {
  tags = {
    owner       = var.admin_username
    environment = "prod-pattern"
    purpose     = "hardened-reference-vm"
    managed_by  = "terraform"
  }
}

resource "azurerm_resource_group" "rg" {
  name     = "rg-${var.prefix}"
  location = var.location
  tags     = local.tags
}

# --- Network ------------------------------------------------------------------
resource "azurerm_virtual_network" "vnet" {
  name                = "vnet-${var.prefix}"
  address_space       = ["10.30.0.0/16"]
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  tags                = local.tags
}

resource "azurerm_subnet" "main" {
  name                 = "snet-main"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = ["10.30.1.0/24"]
}

# Bastion REQUIRES a subnet named exactly "AzureBastionSubnet", /26 or larger.
resource "azurerm_subnet" "bastion" {
  name                 = "AzureBastionSubnet"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = ["10.30.2.0/26"]
}

# Workload NSG: default-deny inbound from the internet (Azure's default), and the
# ONLY allowed SSH is from the Bastion subnet — never from the public internet.
resource "azurerm_network_security_group" "nsg" {
  name                = "nsg-${var.prefix}"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  tags                = local.tags

  security_rule {
    name                       = "allow-ssh-from-bastion-only"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = "10.30.2.0/26" # AzureBastionSubnet
    destination_address_prefix = "*"
  }
}

resource "azurerm_subnet_network_security_group_association" "main" {
  subnet_id                 = azurerm_subnet.main.id
  network_security_group_id = azurerm_network_security_group.nsg.id
}

# --- Azure Bastion (the only way in; the VM has no public IP) ------------------
resource "azurerm_public_ip" "bastion" {
  name                = "pip-bastion-${var.prefix}"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  allocation_method   = "Static"
  sku                 = "Standard"
  tags                = local.tags
}

resource "azurerm_bastion_host" "bastion" {
  name                = "bastion-${var.prefix}"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  sku                 = "Standard"
  tunneling_enabled   = true # enables `az network bastion ssh` from your laptop
  tags                = local.tags

  ip_configuration {
    name                 = "ipcfg"
    subnet_id            = azurerm_subnet.bastion.id
    public_ip_address_id = azurerm_public_ip.bastion.id
  }
}

# --- VM (no public IP) --------------------------------------------------------
resource "azurerm_network_interface" "nic" {
  name                = "nic-${var.prefix}"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  tags                = local.tags

  ip_configuration {
    name                          = "ipcfg"
    subnet_id                     = azurerm_subnet.main.id
    private_ip_address_allocation = "Dynamic"
    # No public_ip_address_id on purpose — private only.
  }
}

resource "azurerm_linux_virtual_machine" "vm" {
  name                            = "vm-${var.prefix}"
  resource_group_name             = azurerm_resource_group.rg.name
  location                        = azurerm_resource_group.rg.location
  size                            = var.vm_size
  admin_username                  = var.admin_username
  network_interface_ids           = [azurerm_network_interface.nic.id]
  disable_password_authentication = true
  tags                            = local.tags

  # Trusted Launch: secure boot + virtual TPM (image must be gen2 + TL-capable).
  secure_boot_enabled = var.enable_trusted_launch
  vtpm_enabled        = var.enable_trusted_launch

  # Encrypts temp disk + caches at the host level (requires a one-time feature
  # registration — see README. Set the var to false if you skip that step).
  encryption_at_host_enabled = var.enable_encryption_at_host

  # Keyless identity for the VM — use it to pull from Key Vault with no secrets.
  identity {
    type = "SystemAssigned"
  }

  # Managed boot diagnostics (no storage account to manage).
  boot_diagnostics {}

  admin_ssh_key {
    username   = var.admin_username
    public_key = file(pathexpand(var.ssh_public_key_path))
  }

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "StandardSSD_LRS" # Premium_LRS for production I/O
  }

  source_image_reference {
    publisher = var.image_publisher
    offer     = var.image_offer
    sku       = var.image_sku
    version   = var.image_version
  }

  # Born-hardened on first boot; a rebuild is identical every time.
  custom_data = base64encode(file("${path.module}/cloud-init.yaml"))

  # Marketplace images may need plan info; uncomment + accept terms (see README):
  # plan {
  #   name      = var.image_sku
  #   publisher = var.image_publisher
  #   product   = var.image_offer
  # }
}

# --- Auto-shutdown (stop paying for an idle VM) -------------------------------
resource "azurerm_dev_test_global_vm_shutdown_schedule" "shutdown" {
  virtual_machine_id    = azurerm_linux_virtual_machine.vm.id
  location              = azurerm_resource_group.rg.location
  enabled               = true
  daily_recurrence_time = var.shutdown_time # 24h, e.g. "1900"
  timezone              = var.timezone

  notification_settings {
    enabled = false # set true + add email/webhook to get a pre-shutdown ping
  }
}
