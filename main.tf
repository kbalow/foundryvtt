provider "aws" {
  profile    = "default"
  region     = "us-east-2"
}

module "foundryvtt" {
  source                  = "Justinon/foundryvtt/aws"
  version                 = "0.0.2"
  # insert the 4 required variables here
  aws_account_id          = var.aws_account_id
  aws_automation_role_arn = var.aws_automation_role_arn
  foundry_password        = var.foundry_password
  foundry_username        = var.foundry_username
}
