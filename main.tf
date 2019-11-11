provider "azurerm"{}

terraform {
  backend "azurerm" {
    resource_group_name  = "SBSA-CIB-Risk-Infrastructure"
    storage_account_name = "sbsasancibrisk001"
    container_name       = "sbsasancibrisk001"
    key                  = "starter.terraform.tfstate"
  }
}

module "terraform_vdc_infra_linux" {
  source = "./vdc-infra-managed"

  hostname = "${var.hostname}"
  deployment_rg = "${var.deployment_rg}"
  deployment_location = "${var.deployment_location}"
  network_security_group = "${var.network_security_group}"
  virtual_network_name = "${var.virtual_network_name}"
  address_space = "${var.address_space}"
  subnet_id = "${var.subnet_id}"
  vm_size = "${var.vm_size}"
  image_publisher = "${var.image_publisher}"
  image_offer = "${var.image_offer}"
  image_sku = "${var.image_sku}"
  image_version = "${var.image_version}"
  admin_username = "${var.admin_username}"
  admin_pw = "${var.admin_pw}"
  diagnostics_storage "${var.diagnostics_storage}"
  tag_source_deployment = "${var.tag_source_deployment}"
  tag_environment_deployment = "${var.tag_environment_deployment}"
}