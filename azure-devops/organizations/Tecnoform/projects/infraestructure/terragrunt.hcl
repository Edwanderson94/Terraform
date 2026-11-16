# Includes the shared Terragrunt configuration for the Tecnoform organization.
include {
  path = find_in_parent_folders("root.hcl")
}

inputs = {
  project_name                 = "Infrastructure"
  oci_region                   = get_env("OCI_REGION")
  oci_object_storage_namespace = get_env("OCI_OBJECT_STORAGE_NAMESPACE")
  oci_tf_state_bucket          = "az-pipeline-tf-state"
  oci_tenancy_ocid             = get_env("OCI_TENANCY_OCID")
  oci_user_ocid                = get_env("OCI_USER_OCID")
  oci_fingerprint              = get_env("OCI_BOOTSTRAP_FINGERPRINT", get_env("OCI_FINGERPRINT"))
  oci_compartment_id           = get_env("OCI_COMPARTMENT_ID")
  aws_access_key_id            = get_env("AWS_ACCESS_KEY_ID")
  aws_secret_access_key        = get_env("AWS_SECRET_ACCESS_KEY")
  aws_session_token            = get_env("AWS_SESSION_TOKEN", "")
  aws_region                   = get_env("AWS_REGION")
  aws_tf_state_bucket          = get_env("AWS_TF_STATE_BUCKET")
  aws_tf_state_key             = get_env("AWS_TF_STATE_KEY")
  aws_tf_state_migrated        = get_env("AWS_TF_STATE_MIGRATED", "false")
}
