# Associate the functioning AWS Variable Group with this stack. Importing must
# never be accompanied by variable or credential changes in the reviewed plan.
import {
  to = module.azuredevops_aws_variablegroup.azuredevops_variable_group.this
  id = "7985f0b1-e29d-431e-babe-1e2f913f4ba7/10"
}

# Adopt existing Environments without creating replacements.
import {
  to = module.azuredevops_environments["oci_bootstrap"].azuredevops_environment.this
  id = "7985f0b1-e29d-431e-babe-1e2f913f4ba7/12"
}

import {
  to = module.azuredevops_environments["aws_cloud"].azuredevops_environment.this
  id = "7985f0b1-e29d-431e-babe-1e2f913f4ba7/13"
}
