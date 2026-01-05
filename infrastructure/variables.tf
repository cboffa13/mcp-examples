variable "cloud_init_script" {
  default = "cloud_init.sh"
}

variable "region" {
  type        = string
  default     = "us-sanjose-1"
  description = "OCI region"
}

variable "compartment_id" {
  type        = string
  description = "OCI compartment ID"
}

variable "availability_domain" {
  type        = string
  default     = ""
  description = "OCI availability domain (leave empty to use the first AD)"
}

variable "shape" {
  type        = string
  default     = "VM.GPU.A10.2"
  description = "Compute instance shape"
}

variable "image_id" {
  type        = string
  default     = "ocid1.image.oc1.us-sanjose-1.aaaaaaaajum4rgadyamrqkrjhvfeg33bpsqrxvwithr2yy7xpjyunpaekioq"
  description = "OCI image ID"
}

variable "ssh_key_path" {
  type        = string
  default     = "~/.ssh/id_rsa"
  description = "Path to SSH private key"
}

variable "vcn_cidr_blocks" {
  type        = list(string)
  default     = ["10.0.0.0/16"]
  description = "List of CIDR blocks for the VCN"
}

variable "subnet_cidr_block" {
  type        = string
  default     = "10.0.1.0/28"
  description = "CIDR block for the public subnet"
}

variable "boot_volume_size_in_gbs" {
  type        = number
  default     = 500
  description = "Boot volume size in GB"
}
