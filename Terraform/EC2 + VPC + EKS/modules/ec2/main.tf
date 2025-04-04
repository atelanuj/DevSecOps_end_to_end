# resource "aws_ebs_volume" "ec2_ebs_volume" {
#   availability_zone = var.ebs_az
#   size              = var.ebc_size
#   type              = var.ebs_type
#   iops              = var.ebs_iops
#   throughput        = var.ebs_throughput
#   tags = {
#     Name = "ec2_ebs_volume"
#   }
# }

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
  instance_type               = var.ec2_instance_name
  associate_public_ip_address = true
  key_name                    = var.ec2_pem_file
  vpc_security_group_ids      = [aws_security_group.ec2_sg.id]
  availability_zone = var.ec2_az
  # ebs_block_device {
  #   device_name = var.ebs_mount_path
  #   # volume_id             = aws_ebs_volume.ec2_ebs_volume.id
  #   delete_on_termination = true
  #   volume_size          = var.ebc_size

  # }
  # depends_on = [aws_ebs_volume.ec2_ebs_volume]
  tags = {
    Name = var.ec2_name
  }
}

# # Attach the EBS volume to the EC2 instance
# resource "aws_volume_attachment" "ec2_volume_attachment" {
#   device_name  = var.ebs_mount_path
#   volume_id    = aws_ebs_volume.ec2_ebs_volume.id
#   instance_id  = aws_instance.test-ec2.id
#   force_detach = true
#   depends_on   = [aws_ebs_volume.ec2_ebs_volume, aws_instance.test-ec2]
# }