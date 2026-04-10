resource "aws_instance" "vault-ec2" {
  ami           = "ami-05d2d839d4f73aafb"
  instance_type = "m7i-flex.large"
  key_name      = "anujpem"
  associate_public_ip_address = true
  vpc_security_group_ids = ["sg-046d026f055e384e9"]

  tags = {
    Name = "Vault-Terraform-EC2-by-assumed-role"
  }
}

resource "aws_s3_bucket" "vault-s3" {
  bucket = "vault-s3-bucket-by-assumed-role123456"
  tags = {
    Name = "Vault-Terraform-S3-Bucket-by-assumed-role"
  }
}