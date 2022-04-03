provider "aws" {
  region = var.region
}
resource "aws_key_pair" "tharwat-key" {
  key_name = var.key_name
  public_key = var.public_key
}
resource "aws_security_group" "tharwat-SG" {

  name        = var.Security-group-name
  description = "Allow TLS inbound traffic"
  vpc_id      = var.vpc_id

  ingress {
    description      = "TLS from VPC"
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]

  }

  ingress {
    description      = "TLS from VPC"
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]

  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]

  }

  tags = {
    Name = "allow_tls"
  }
}

resource "aws_instance" "instancetharwat" {
  ami = var.ami
  instance_type = var.instance_type
  tags = {
    "Name" = var.ec2tag
  }
  key_name = aws_key_pair.tharwat-key.key_name
  vpc_security_group_ids=[aws_security_group.tharwat-SG.id]


 connection {
  type = "ssh"
  host = self.public_ip
  user = "ec2-user"
  private_key = file(var.private_key) 
 }
  provisioner "file"{
  source = "my_script.sh"
  destination = "/home/ec2-user"
  }
  

  provisioner "file"{
  source = "index.php"
  destination = "/home/ec2-user"
  }
  provisioner "remote-exec"{
    inline = [
          "sudo yum install httpd",
          "sudo systemctl enable httpd",
          "sudo systemctl start httpd",
          "sudo cp /home/ec2-user/webApp.php /var/www/html"
          
      ]
  }
  
}


