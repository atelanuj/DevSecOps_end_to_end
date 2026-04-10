# Optional: Output the found AMI ID
output "latest_amazon_linux_2023_ami_id" {
  description = "The ID of the latest Amazon Linux 2023 AMI found."
  # value       = data.aws_ami.ubuntu.id
  value = aws_instance.test-ec2.ami
}

output "aws_instance_public_ip" {
  description = "The public IP address of the EC2 instance."
  value       = aws_instance.test-ec2.public_ip
}

output "aws_instance_id" {
  description = "The ID of the EC2 instance."
  value       = aws_instance.test-ec2.id

}
# output "aws_ebs_volume_id" {
#   description = "The ID of the ebs volume."
#   value       = aws_ebs_volume.ec2_ebs_volume.id

# }