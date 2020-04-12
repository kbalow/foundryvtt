provider "aws" {
  profile    = "default"
  region     = "us-east-2"
}

data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-trusty-14.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] # Canonical
}

resource "aws_instance" "foundry" {
  connection {
    user = "ubuntu"
    host = aws_instance.foundry.public_ip
    private_key = var.foundry_pem
  }
  ami           = data.aws_ami.ubuntu.id
  instance_type = "t2.micro"
  security_groups = ["ssh","http_https"]
  key_name = "foundry_vtt"
  tags = {
      Name = "foundry"
      Owner = "kbalow"
    }
  provisioner "remote-exec" {
    inline = [
      "sudo apt-get -y update",
      "sudo apt install -y libssl-dev",
      "curl -sL https://deb.nodesource.com/setup_12.x | sudo bash -",
      "sudo apt install -y nodejs nginx",
      "sudo service nginx start",
      "mkdir -p /home/ubuntu/{foundryvtt,foundrydata}",
      "wget ${var.foundry_link} -O foundryvtt.zip",
      "unzip foundryvtt.zip",
    ]
  }
}

resource "aws_eip" "eip" {
  instance = aws_instance.foundry.id
  vpc = true
  #cidr_block = "0.0.0.0"
}

resource "aws_route53_record" "foundry" {
  zone_id = "Z10007922NRYP4XPDOX31"
  name    = "foundry2.balow.me" ##
  type    = "A"
  ttl     = "300"
  records = ["${aws_eip.eip.public_ip}"]
}

output "instance_ip_addr" {
  value       = "${aws_instance.foundry.public_ip}"
  description = "AWS Web IP"
}