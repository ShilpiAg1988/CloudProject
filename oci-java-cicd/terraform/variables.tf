
variable "compartment_ocid" {
  description = "Compartment OCID"
  type        = string
}
variable "tenancy_ocid" {
  description = "Tenancy OCID"
  type        = string
}
variable "user_ocid" {
  description = "User OCID"
  type        = string
}
variable "fingerprint" {
  description = "API Key Fingerprint"
  type        = string
}
variable "private_key_path" {
  description = "Path to API Private Key"
  type        = string
}
variable "ssh_public_key" {
  description = "Public key for OKE worker node access"
  type        = string
}
variable "ssh_private_key" {
  description = "Private key for OKE worker node access"
  type        = string
}
