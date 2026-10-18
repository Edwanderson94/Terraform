# ================================================================
# Variables
# ================================================================

variable "org_service_url" {
  description = "URL da organizacao no Azure DevOps"
  type        = string
}

variable "personal_access_token" {
  description = "PAT de acesso a organizacao no Azure DevOps"
  type        = string
  sensitive   = true
}

variable "project_name" {
  description = "Nome do projeto no Azure DevOps"
  type        = string
}

variable "oci_region" {
  description = "Regiao OCI usada pelo bootstrap."
  type        = string
}

variable "oci_object_storage_namespace" {
  description = "Namespace do Object Storage OCI."
  type        = string
}

variable "oci_tf_state_bucket" {
  description = "Nome do bucket OCI usado pelo state."
  type        = string
}

variable "oci_tenancy_ocid" {
  description = "OCID da tenancy OCI."
  type        = string
  sensitive   = true
}

variable "oci_user_ocid" {
  description = "OCID do usuario OCI."
  type        = string
  sensitive   = true
}

variable "oci_fingerprint" {
  description = "Fingerprint da chave OCI."
  type        = string
  sensitive   = true
}

variable "oci_compartment_id" {
  description = "OCID do compartment OCI do bucket."
  type        = string
  sensitive   = true
}

