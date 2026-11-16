# GitHub Actions configuration

Repository: `Edwanderson94/Terraform`.

Repository Actions Variables used by plan/apply:

- `AZDO_ORG_SERVICE_URL`
- `OCI_REGION`
- `OCI_OBJECT_STORAGE_NAMESPACE`
- `OCI_TF_STATE_BUCKET` (`gh-pipeline-tf-state`)
- `OCI_TF_STATE_MIGRATED` (`true` after verified state consolidation)

Repository Actions Secrets:

- `AZDO_PERSONAL_ACCESS_TOKEN`
- `OCI_TENANCY_OCID`
- `OCI_USER_OCID`
- `OCI_FINGERPRINT`
- `OCI_BOOTSTRAP_FINGERPRINT` (fingerprint of the Azure DevOps Secure File;
  distinct from the signing key used by the GitHub backend)
- `OCI_COMPARTMENT_ID`
- `OCI_PRIVATE_KEY`

Existing non-sensitive Secrets are retained for compatibility with older workflow
revisions; the updated workflow reads those settings through `vars` instead.
OCI Secrets already validated by successful workflows are preserved when local
shell credentials differ from the working identity. Never overwrite them with
an unverified shell fingerprint or a mismatched signing key.

AWS workload credentials are separate from the credentials used to administer
Azure DevOps. The requested `terraform-aws-pipeline` identity is supplied through
Secrets `AWS_ACCESS_KEY_ID` and `AWS_SECRET_ACCESS_KEY`; `AWS_SESSION_TOKEN` is
optional for temporary credentials. Non-secret group configuration uses Variables
`AWS_REGION`, `AWS_TF_STATE_BUCKET`, `AWS_TF_STATE_KEY` and
`AWS_TF_STATE_MIGRATED`, initialized from existing group ID 10.
Never upload an empty secret or substitute an unrelated AWS profile. Apply must
remain blocked until the matching secret is available from the approved source.
