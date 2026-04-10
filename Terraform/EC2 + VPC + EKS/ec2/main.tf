resource "aws_instance" "example" {
  ami           = "ami-05d2d839d4f73aafb"
  instance_type = "m7i-flex.large"
  key_name      = "anujpem"
  associate_public_ip_address = true
  security_groups = ["sg-046d026f055e384e9"]

  tags = {
    Name = "Vault-Terraform-EC2-by-assumed-role"
  }
}