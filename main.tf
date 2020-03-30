provider "aws" {
  profile    = "default"
  region     = "${var.aws_region}"
}

resource "aws_instance" "webVm" {
  connection {
    user = "ubuntu"
    host = "${self.public_ip}"
    private_key = "${file(var.aws_private_key_path)}"
  }
  ami           = "${var.aws_ami}"
  instance_type = "${var.aws_vm_size}"
  security_groups = ["web_only","ssh_only"]
  key_name = "${var.aws_key_name}"
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
  vpc = true
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