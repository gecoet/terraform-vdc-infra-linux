output "vm_id" {
  description = "Reference to a VM with which this NIC has been associated"
  value = "${module.terraform_vdc_infra_managed.vm_id}"
}