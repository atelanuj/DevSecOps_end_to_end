resource "aws_security_group" "ec2_sg" {
  name        = var.sg_name
  description = "Default security group for EC2 instance"

  ingress {
    description = "Enable All traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    description = "Enable 80 traffic"
    from_port   = var.enable_port_80
    to_port     = var.enable_port_80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "test-ec2" {
  ami                         = var.ami_id
  instance_type               = "t2.micro"
  associate_public_ip_address = true
  key_name                    = "DevOps"
  vpc_security_group_ids      = [aws_security_group.ec2_sg.id]

  tags = {
    Name = "test-ec2"
  }
}