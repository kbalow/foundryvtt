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
      "sudo apt -y update",
      "sudo apt install -y libssl-dev",
      "curl -sL https://deb.nodesource.com/setup_13.x | sudo -E bash -",
      "sudo apt install -y nodejs", ##backticks?
      "sudo apt install -y nginx unzip systemd",
      "sudo rm /etc/nginx/sites-enabled/default",
      "sudo service nginx restart",
      "sudo npm install pm2 -g",
      "mkdir -p /home/ubuntu/foundryvtt",
      "mkdir -p /home/ubuntu/foundrydata",
      "wget ${var.foundry_link} -O foundryvtt.zip",
      "unzip foundryvtt.zip",
      "sudo service nginx start",
      "node resources/app/main.js --dataPath=$HOME/foundrydata",
      "sudo env PATH=$PATH:/usr/bin /usr/lib/node_modules/pm2/bin/pm2 startup systemd -u ubuntu --hp /home/ubuntu",
      "pm2 startup",
      "pm2 start /home/ubuntu/foundry/resources/app/main.js --name \"foundry\" -- --port=8080",
    ]
  }
}

resource "aws_eip" "eip" {
  instance = aws_instance.foundry.id
  vpc = true
  #cidr_block = "0.0.0.0"
}

resource "aws_route53_record" "foundry" {
  zone_id = var.hosted_zone_id
  name    = var.hosted_zone_record_name
  type    = "A"
  ttl     = "300"
  records = ["${aws_eip.eip.public_ip}"]
}

output "instance_ip_addr" {
  value       = "${aws_instance.foundry.public_ip}"
  description = "Foundry IP Address"
}