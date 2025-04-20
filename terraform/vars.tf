##############################
# Standard Project Variables #
##############################
variable "service_name" {
  description = "Logical name of the service (e.g., resume, blog, api)"
  type        = string
  default     = "resume"
}

variable "environment" {
  description = "Deployment environment (e.g., dev, staging, prod)"
  type        = string
}

variable "region_code" {
  description = "AWS region code (e.g., use1)"
  type        = string
}

variable "aws_region" {
  description = "AWS region to deploy into"
  type        = string
  default     = "us-east-1"
}

variable "org_name" {
  description = "Organization prefix for naming"
  type        = string
  default     = "biotornic"
}

variable "tfc_workspace_name" {
  description = "Terraform Cloud workspace name"
  type        = string
}

variable "vcs_repo" {
  description = "VCS repository identifier"
  type        = string
}
