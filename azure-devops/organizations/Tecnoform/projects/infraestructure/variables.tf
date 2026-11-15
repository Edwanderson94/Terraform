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

variable "aws_access_key_id" {
  description = "Access key ID da identidade AWS usada pelas pipelines."
  type        = string
}

variable "aws_secret_access_key" {
  description = "Secret access key da identidade AWS usada pelas pipelines."
  type        = string
  sensitive   = true
}

variable "aws_session_token" {
  description = "Session token temporario da identidade AWS, quando aplicavel."
  type        = string
  default     = null
  nullable    = true
  sensitive   = true
}

variable "aws_region" {
  description = "Regiao AWS usada pelas pipelines."
  type        = string
}

variable "aws_tf_state_bucket" {
  description = "Bucket S3 usado pelo state Terraform AWS."
  type        = string
}

variable "aws_tf_state_key" {
  description = "Chave S3 usada pelo state Terraform AWS."
  type        = string
}

variable "aws_tf_state_migrated" {
  description = "Indica se o backend remoto AWS foi migrado e validado."
  type        = string
  default     = "false"
}

