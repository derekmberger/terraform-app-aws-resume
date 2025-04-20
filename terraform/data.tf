data "aws_region" "current" {}
data "aws_caller_identity" "current" {}
data "aws_elb_service_account" "elb_account" {}

data "aws_route53_zone" "hosted_zone" {
  name = "biotornic.com"
}

data "terraform_remote_state" "vpc" {
  backend = "remote"
  config = {
    organization = var.org_name
    workspaces   = { name = "infra-aws-vpc-${var.region_code}-${var.environment}" }
  }
}

data "terraform_remote_state" "ecs" {
  backend = "remote"
  config = {
    organization = var.org_name
    workspaces   = { name = "infra-aws-ecs-${var.region_code}-${var.environment}" }
  }
}
