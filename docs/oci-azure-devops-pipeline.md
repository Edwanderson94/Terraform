# OCI state backend and Azure Pipelines

This repository uses the Terraform `oci` backend with OCI Object Storage. The
state is remote, locked by Terraform, and never committed or published as a
pipeline artifact. OCI Object Storage encrypts objects at rest by default; the
state bucket must remain private and have versioning enabled.

## What this pipeline does

- A pull request and a push to `develop` run format and validation only.
- A push to `master` runs validation, creates one Terraform plan, and publishes
  it only to the same pipeline run for the protected deployment stage.
- The apply stage is disabled until `OCI_TF_STATE_MIGRATED` is set to `true` in
  the protected Azure DevOps variable group.
- The `terraform-oci-production` Environment can have an approval and an
  exclusive-lock check. Those controls are configured in Azure DevOps, not in
  YAML.

Do not publish `tfplan`, `.terraform`, `backend.tf`, or a state file as a
pipeline artifact. Backend credentials can otherwise be persisted in those
files.

## 1. Bootstrap OCI outside this stack

Create these resources in the OCI Console or from a separate, one-time
bootstrap process:

1. Create a private Standard Object Storage bucket, for example
   `tecnoform-terraform-state`. Enable **Object Versioning**.
2. Create a dedicated OCI IAM user and group for the pipeline, rather than
   using a personal user. Give the group access only to this bucket. A starting
   policy pattern is:

   ```text
   Allow group terraform-state-writers to inspect buckets in compartment <compartment-name>
   Allow group terraform-state-writers to manage objects in compartment <compartment-name> where target.bucket.name = 'tecnoform-terraform-state'
   ```

   The backend needs object inspect, create, read, and delete permissions to
   maintain the state and its lock object.
3. Create an **API signing key** for that service user and upload its public
   key in OCI IAM. This is an RSA PEM API key, not the SSH key used for Compute
   access.
4. Record the tenancy OCID, service-user OCID, API-key fingerprint, selected
   region, Object Storage namespace, and bucket name. Do not place the private
   key in this repository.

OCI encrypts Object Storage data at rest with AES-256 by default. If a
customer-managed key is required later, create it in OCI Vault and set the
bucket to use it before migrating state.

## 2. Configure Azure DevOps secrets

In **Pipelines > Library**, create a protected variable group named
`terraform-oci`. Restrict it to this pipeline and add:

| Variable | Secret | Value |
| --- | --- | --- |
| `AZDO_ORG_SERVICE_URL` | No | `https://dev.azure.com/Tecnoform` |
| `AZDO_PERSONAL_ACCESS_TOKEN` | Yes | Azure DevOps PAT with only the permissions this stack needs |
| `OCI_TENANCY_OCID` | Yes | OCI tenancy OCID |
| `OCI_USER_OCID` | Yes | OCI pipeline service-user OCID |
| `OCI_FINGERPRINT` | Yes | OCI API-key fingerprint |
| `OCI_REGION` | No | OCI region, such as `sa-saopaulo-1` |
| `OCI_OBJECT_STORAGE_NAMESPACE` | No | OCI Object Storage namespace |
| `OCI_TF_STATE_BUCKET` | No | State bucket name |
| `OCI_TF_STATE_MIGRATED` | No | Start with `false`; set to `true` only after step 4 |

In **Pipelines > Library > Secure files**, upload the API private key under the
exact name `oci-terraform-api-key.pem`, authorize only this pipeline, and do
not expose its content in job logs. The pipeline downloads it only for the job;
Azure DevOps deletes secure files when the job ends.

The YAML maps those protected uppercase variables to the lowercase
`OCI_<backend_attribute>` names expected by the Terraform OCI backend. Do not
rename either side without updating that mapping.

The `terraform-plan` artifact is sensitive because Terraform plans can contain
resource values. Restrict pipeline and artifact permissions to the project
administrators and the infrastructure team, and use a short retention period.
The Apply stage downloads that exact plan after the `terraform-oci-production`
Environment checks; it does not recalculate a different plan.

## 3. Create and protect the pipeline

Create an Azure Pipeline from `azure-pipelines.yml` in the `Infrastructure`
project. Create the Environment named `terraform-oci-production` and restrict
pipeline permissions to this pipeline.

Recommended checks on that Environment:

- **Approval**: require the infrastructure owner before the master deployment;
- **Exclusive lock**: avoid queued runs competing for the same stack;
- **Branch control**: allow only `refs/heads/master`, with branch protection
  required.

The OCI backend also provides Terraform state locking. The Environment lock is
an additional delivery control, not a replacement for backend locking.

## 4. Migrate the existing local state once

The repository previously used a local backend. Before enabling an automatic
apply, run the migration from the workstation that holds the current state,
with the OCI environment variables set and an encrypted backup stored outside
the repository:

```bash
cd azure-devops/organizations/Tecnoform/projects/infraestructure
terragrunt init -migrate-state
terragrunt state pull >/dev/null
terragrunt plan
```

Review the migration prompt and verify that the plan has no unexpected creates,
updates, or destroys. Test state locking with a second `plan` before enabling
the pipeline. Do not use `-force-copy`; retain the local backup until recovery
has been tested.

After this migration and verification, change `OCI_TF_STATE_MIGRATED` to
`true`. Subsequent pushes to `master` will run the automated plan/apply flow.

## References

- [Terraform OCI backend](https://developer.hashicorp.com/terraform/language/backend/oci)
- [OCI API signing keys](https://docs.oracle.com/en-us/iaas/Content/API/Concepts/apisigningkey.htm)
- [Azure Pipelines approvals and checks](https://learn.microsoft.com/azure/devops/pipelines/process/approvals)
- [Azure Pipelines secure files](https://learn.microsoft.com/azure/devops/pipelines/tasks/reference/download-secure-file-v1)
