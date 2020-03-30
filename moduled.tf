module "ec2-instance" {
  source  = "terraform-aws-modules/ec2-instance/aws"
  version = "2.13.0"
  # insert the 10 required variables here
  ami = "${var.ami}"
  associate_public_ip_address = true
  instance_type = "${var.instance_type}"
  ipv6_address_count = 0
  ipv6_addresses = {}
  name = "foundryvtt"
  private_ip = {}
  user_data = {}
  user_data_base64 = {}
  vpc_security_group_ids = {}
}

module "web_server_sg" {
  source = "terraform-aws-modules/security-group/aws//modules/http"

  name        = "web-server"
  description = "Security group for web-server with HTTP ports open within VPC"
  vpc_id      = "vpc-12345678"

  ingress_cidr_blocks = ["0.0.0.0/0"]
}