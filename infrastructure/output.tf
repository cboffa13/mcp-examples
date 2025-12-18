output "instance_public_ip" {
  value = oci_core_instance.luna_instance.public_ip
}

output "vcn_id" {
  value = oci_core_vcn.luna_vcn.id
}

output "subnet_id" {
  value = oci_core_subnet.luna_public_subnet.id
}

output "compartment_id" {
  value = oci_core_instance.luna_instance.compartment_id
}
