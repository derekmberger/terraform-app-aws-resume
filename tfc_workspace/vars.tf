#################
# TFE Variables #
#################
variable "tfc_organization" {
  description = "The organization in TFC to create the workspace in"
  type        = string
  default     = "biotornic"
}

variable "tfc_workspace_auto_apply" {
  description = "Should the created TFC workspace auto apply"
  type        = string
  default     = "false"
}

variable "terraform_version" {
  description = "The version of Terraform to use in the workspace"
  type        = string
  default     = "1.11.4"
}

variable "vcs_repo_terraform_working_directory" {
  description = "The directory in the VCS repo that contains the code for TFC to deploy"
  type        = string
  default     = "terraform"
}

variable "vcs_repo" {
  description = "The org/name of the repo to use"
  type        = string
  default     = "derekmberger/terraform-app-aws-resume"
}

variable "vcs_branch" {
  description = "The branch of the VCS repo to track for changes"
  type        = string
}

##############################
# Standard Project Variables #
##############################
variable "aws_region" {
  description = "The main AWS region to deploy the resources into"
  type        = string
  default     = "us-east-1"
}

variable "region_code" {
  description = "AWS region code, e.g. use1"
  type        = string
  default     = "use1"
}

variable "environment" {
  description = "Environment tag, e.g. dev | staging | prod"
  type        = string
}

variable "org_name" {
  description = "The organization prefix"
  type        = string
  default     = "biotronic"
}

############################
# Custom Project Variables #
############################
variable "service_name" {
  description = "Logical name of the service (e.g., resume, blog, api)"
  type        = string
}
