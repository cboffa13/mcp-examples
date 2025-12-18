provider "oci" {
  region = var.region
}

data "oci_identity_availability_domains" "ads" {
  compartment_id = var.compartment_id
}

# Create a new VCN
resource "oci_core_vcn" "luna_vcn" {
  compartment_id = var.compartment_id
  cidr_blocks    = ["10.0.0.0/16"]
  display_name   = "luna-vcn"
}

resource "oci_core_internet_gateway" "luna_internet_gateway" {
  compartment_id = var.compartment_id
  vcn_id         = oci_core_vcn.luna_vcn.id
  display_name   = "luna-internet-gateway"
}

resource "oci_core_route_table" "luna_route_table" {
  compartment_id = var.compartment_id
  vcn_id         = oci_core_vcn.luna_vcn.id
  display_name   = "luna-route-table"

  route_rules {
    destination       = "0.0.0.0/0"
    destination_type  = "CIDR_BLOCK"
    network_entity_id = oci_core_internet_gateway.luna_internet_gateway.id
  }
}

# Create a public subnet in the VCN
resource "oci_core_subnet" "luna_public_subnet" {
  compartment_id             = var.compartment_id
  vcn_id                     = oci_core_vcn.luna_vcn.id
  cidr_block                 = "10.0.1.0/28"
  display_name               = "luna-public-subnet"
  prohibit_public_ip_on_vnic = false
  security_list_ids          = [oci_core_security_list.luna_security_list.id]
  route_table_id             = oci_core_route_table.luna_route_table.id
}

# Create a security list for the VCN
resource "oci_core_security_list" "luna_security_list" {
  compartment_id = var.compartment_id
  vcn_id         = oci_core_vcn.luna_vcn.id
  display_name   = "luna-security-list"

  # Ingress security rules
  ingress_security_rules {
    protocol = "6" # TCP
    source   = "0.0.0.0/0"
    tcp_options {
      min = 22
      max = 22
    }
    description = "Allow SSH traffic"
  }

  ingress_security_rules {
    protocol = "6" # TCP
    source   = "0.0.0.0/0"
    tcp_options {
      min = 11434
      max = 11434
    }
    description = "Allow Ollama traffic"
  }

  # Egress security rules
  egress_security_rules {
    protocol    = "all"
    destination = "0.0.0.0/0"
  }
}

# Update the instance to use the new subnet
resource "oci_core_instance" "luna_instance" {
  availability_domain = length(var.availability_domain) > 0 ? var.availability_domain : data.oci_identity_availability_domains.ads.availability_domains[0].name
  compartment_id      = var.compartment_id
  shape               = var.shape

  source_details {
    source_type             = "image"
    source_id               = var.image_id
    boot_volume_size_in_gbs = 500
  }

  create_vnic_details {
    subnet_id        = oci_core_subnet.luna_public_subnet.id
    assign_public_ip = "true"
  }

  metadata = {
    ssh_authorized_keys = file("${var.ssh_key_path}.pub")
    user_data           = base64encode(file(var.cloud_init_script))
  }


  shape_config {
    ocpus         = 30
    memory_in_gbs = 480
  }
}

resource "null_resource" "wait_for_cloudinit" {
  depends_on = [oci_core_instance.luna_instance]
  provisioner "remote-exec" {
    connection {
      type        = "ssh"
      host        = oci_core_instance.luna_instance.public_ip
      user        = "opc"
      private_key = file(var.ssh_key_path)
    }

    inline = [
      "sudo cloud-init status --wait > /dev/null",
      "sudo reboot",
    ]
  }
}