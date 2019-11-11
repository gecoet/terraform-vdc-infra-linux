output "vm_id" {
  description = "ID of the Virtual Machine."
  value = "${azurerm_virtual_machine.vm.id}"
}

output "vm_name" {
  description = "The name of the vm."
  value = "${azurerm_virtual_machine.vm.name}"
}

output "vm_ip" {
  description = "vm_ip."
  value = "${azurerm_network_interface.nic.private_ip_address}"
}