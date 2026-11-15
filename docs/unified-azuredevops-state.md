# Shared Azure DevOps state

Infrastructure and Platform control-plane resources share one state:

- Bucket: `gh-pipeline-tf-state`
- Object: `projects/infraestructure/terraform.tfstate`
- Terragrunt entry point: `azure-devops/organizations/Tecnoform/projects/infraestructure`

The former Platform bootstrap entry point is retired. Do not run Terraform from
`projects/platform`; its files are historical bootstrap reference only.
`azuredevops_project.platform` is now declared in the shared entry point.

The original Platform state record was transferred into the existing shared
state, retaining project identity and feature settings. No Azure DevOps project
was recreated. Backups are stored outside Git in the operator's protected OCI
configuration directory. Never restore a backup over a newer state without
reviewing its lineage, serial and subsequent changes.

AWS/OCI workload states and the state that manages the backend bucket remain
independent. Variable Group reconciliation is tracked separately in PR #16.
