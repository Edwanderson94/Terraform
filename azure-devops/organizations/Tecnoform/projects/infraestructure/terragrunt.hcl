# Includes the shared Terragrunt configuration for the Tecnoform organization.
include {
  path = find_in_parent_folders("root.hcl")
}

inputs = {
  project_name                 = "Infrastructure"
  oci_region                   = get_env("OCI_REGION")
  oci_object_storage_namespace = get_env("OCI_OBJECT_STORAGE_NAMESPACE")
  oci_tf_state_bucket          = get_env("OCI_TF_STATE_BUCKET")
  oci_tenancy_ocid             = get_env("OCI_TENANCY_OCID")
  oci_user_ocid                = get_env("OCI_USER_OCID")
  oci_fingerprint              = get_env("OCI_FINGERPRINT")
  oci_compartment_id           = get_env("OCI_COMPARTMENT_ID")
}
