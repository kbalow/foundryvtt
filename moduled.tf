module "ec2_instance" {
  source  = "app.terraform.io/Balow/ec2-instance/aws"
  version = "2.13.0"

  ami = "ami-07ebfd5b3428b6f4d"
  associate_public_ip_address = "true"
  instance_type = "t2.micro"
  ipv6_address_count = "${var.ec2_instance_ipv6_address_count}"
  ipv6_addresses = "${var.ec2_instance_ipv6_addresses}"
  name = "foundry_server"
  private_ip = "${var.ec2_instance_private_ip}"
  user_data = "${var.ec2_instance_user_data}"
  user_data_base64 = "${var.ec2_instance_user_data_base64}"
  vpc_security_group_ids = "${var.ec2_instance_vpc_security_group_ids}"
}