####################
# Project Variables #
#####################
resource "tfe_variable" "aws_region" {
  category     = "terraform"
  key          = "aws_region"
  value        = var.aws_region
  workspace_id = tfe_workspace.workspace.id
}

resource "tfe_variable" "region_code" {
  category     = "terraform"
  key          = "region_code"
  value        = var.region_code
  workspace_id = tfe_workspace.workspace.id
}

resource "tfe_variable" "environment" {
  category     = "terraform"
  key          = "environment"
  value        = var.environment
  workspace_id = tfe_workspace.workspace.id
}

resource "tfe_variable" "tfc_workspace_name" {
  category     = "terraform"
  key          = "tfc_workspace_name"
  value        = tfe_workspace.workspace.name
  workspace_id = tfe_workspace.workspace.id
}

resource "tfe_variable" "vcs_repo" {
  category     = "terraform"
  key          = "vcs_repo"
  value        = var.vcs_repo
  workspace_id = tfe_workspace.workspace.id
}

resource "tfe_variable" "org_name" {
  category     = "terraform"
  key          = "org_name"
  value        = var.org_name
  workspace_id = tfe_workspace.workspace.id
}

############################
# Custom Project Variables #
############################
resource "tfe_variable" "service_name" {
  category     = "terraform"
  key          = "service_name"
  value        = var.service_name
  workspace_id = tfe_workspace.workspace.id
}
