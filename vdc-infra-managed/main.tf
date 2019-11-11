
# Defining the Resource Group for vm's 
data "azurerm_resource_group" "rg" {
  name = var.deployment_rg
}
# The network security group used for vm
data "azurerm_network_security_group" "nsg" {
  name                = "${var.network_security_group}"
  resource_group_name = "${data.azurerm_resource_group.rg.name}"
}
# The vnet allocated to the vm's
data "azurerm_virtual_network" "vnet" {
  name                = "${var.virtual_network_name}"
  resource_group_name = "${data.azurerm_resource_group.rg.name}"
}
# The subnet allocated to the vm's
data "azurerm_subnet" "subnet" {
  name                 = "${var.subnet_id}"
  virtual_network_name = "${var.virtual_network_name}"
  resource_group_name  = "${data.azurerm_resource_group.rg.name}"
}
# The storage account for diagnostics
data "azurerm_storage_account" "diag" {
  name                = "${var.diagnostics_storage"
  resource_group_name = "${var.diagnostics_resource_group}"
}

# Creat network interface card per vm
resource "azurerm_network_interface" "nic" {
  name                = "${var.hostname}-nic"
  location            = "${data.azurerm_resource_group.rg.location}"
  resource_group_name = "${data.azurerm_resource_group.rg.name}"

# Define a subnet to run the VMs in. These variables can be defined 
  ip_configuration {
    name                          = "ipconfiguration1"
    subnet_id                     = "${data.azurerm_subnet.subnet.id}"
    private_ip_address_allocation = "Dynamic"
  }
}
# Creat virtual Machine
resource "azurerm_virtual_machine" "vm" {
  name                  = "${var.hostname}-vm"
  location              = "${var.deployment_location}"
  resource_group_name   = "${data.azurerm_resource_group.rg.name}"
  network_interface_ids = ["${azurerm_network_interface.nic.id}"]
  vm_size               = "${var.vm_size}"

  storage_image_reference {
    publisher = "${var.image_publisher}"
    offer     = "${var.image_offer}"
    sku       = "${var.image_sku}"
    version   = "${var.image_version}"
  }
  storage_os_disk {
    name              = "${var.hostname}-vm-osdisk"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Standard_LRS"
  }
  os_profile {
    computer_name  = "${var.hostname}"
    admin_username = "${var.admin_username}"
    admin_password = "${var.admin_pw}"
  }
  os_profile_linux_config {
    disable_password_authentication = false
  }
  boot_diagnostics {
    enabled     = "${var.boot_diagnostics}"
    storage_uri = "${var.boot_diagnostics == "true" ? join(",", azurerm_storage_account.diag.*.primary_blob_endpoint) : "" }"
  }
}
  tags = {
    source = var.tag_source_deployment
    environment = var.tag_environment_deployment
  }
}

