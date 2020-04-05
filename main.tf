provider "aws" {
  profile    = "default"
  region     = "us-east-2"
}

resource "aws_instance" "foundry" {
  connection {
    user = "ubuntu"
    host = "${self.public_ip}"
    private_key = "${var.foundrypem}"
  }
  ami           = "ami-07ebfd5b3428b6f4d"
  instance_type = "t2.micro"
  security_groups = ["web_only","ssh_only"]
  key_name = "foundry"
  tags = {
      Name = "webserver"
      Owner = "kbalow"
    }
  provisioner "remote-exec" {
    inline = [
      "sudo apt-get -y update",
      "sudo apt-get -y install nginx",
      "sudo service nginx start",
    ]
  }
}

resource "aws_eip" "eip" {
  instance = "${aws_instance.foundry.id}"
  vpc = true
  cidr_block = "0.0.0.0"
}

resource "aws_route53_record" "www" {
  zone_id = "Z215KKUHO0EF1N"
  name    = "${var.record_name}"
  type    = "A"
  ttl     = "300"
  records = ["${aws_eip.eip.public_ip}"]
}

output "instance_ip_addr" {
  value       = "${aws_instance.webVm.public_ip}"
  description = "AWS Web IP"
}