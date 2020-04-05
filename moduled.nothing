provider "aws" {
  region = "us-west-2"
  access_key = "${var.aws_access_key}"
  secret_key = "${var.aws_secret_key}"
}

module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "2.21.0"

  name = "foundry_vtt"
  cidr = 0.0.0.0/0

  #azs             = var.vpc_azs
  #private_subnets = var.vpc_private_subnets
  #public_subnets  = var.vpc_public_subnets

  #enable_nat_gateway = var.vpc_enable_nat_gateway

  #tags = var.vpc_tags
}

module "ec2_instance" {
  source  = "terraform-aws-modules/ec2-instance/aws"
  version = "2.12.0"

  name           = "foundry_vtt"
  instance_count = 1

  ami                    = "ami-07ebfd5b3428b6f4d"
  instance_type          = "t2.micro"
  vpc_security_group_ids = [module.vpc.default_security_group_id]
  subnet_id              = module.vpc.public_subnets[0]

  tags = {
    Terraform   = "true"
    Environment = "foundry"
  }
}