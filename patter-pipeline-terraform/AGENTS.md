# Repository guidance

Before changing pipeline behavior, read
[the Terraform pipeline steering](.codex/steering/terraform-pipeline.md).
When integrating this template into an infrastructure repository, use the
[`terraform-pipeline-integration` skill](.agents/skills/terraform-pipeline-integration/SKILL.md).

Keep shared pipeline logic generic and update the README whenever template
parameters or behavior change. Never commit credentials, Terraform state,
plans, or generated backend files.
