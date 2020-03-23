variable "aws_private_key_path" {
  default = "~/.ssh/koryb_puttyGen.pem"
}

variable "aws_key_name" {
  default = "koryb_puttyGen"
}

variable "aws_region" {
  default = "us-east-2"
}

variable "aws_vm_size" {
  default = "t2.micro"
}

variable "aws_ami" {
  default = "ami-05c1fa8df71875112"
}

variable "record_name" {
  default = "www.balow.me"
}