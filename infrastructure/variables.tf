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
