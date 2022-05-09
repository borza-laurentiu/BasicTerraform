provider "aws" {
    region = "eu-west-2"
    access_key = var.aws_access_key
    secret_key = var.aws_secret_key
}

resource "aws_security_group" "sgApp2" { 
  name        = "sgApp2"
  description = "allow http and ssh access"
  vpc_id      = "vpc-0a06473c5d624cf0f"

  ingress { 
    description = "ssh access"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress { 
    description = "http access"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  
  egress {
        to_port = 0
        from_port = 0
        protocol = -1
        cidr_blocks = ["0.0.0.0/0"]
   }
}

resource "aws_instance" "webserver" {
  ami                         = "ami-0015a39e4b7c0966f"
  instance_type               = "t2.micro"
  key_name                    = "New-Key"
  subnet_id                   = "subnet-0f99bc33319acef12"  //related to the vpc   
  vpc_security_group_ids       = [aws_security_group.sgApp2.id]   //reference it to the security group below
  associate_public_ip_address = true       

  tags = {
    Name = "Larry's Machine"
  }
}

output "aws_ec2_ip" {
    value = aws_instance.webserver.public_ip //logs the IP address of the EC2 
}