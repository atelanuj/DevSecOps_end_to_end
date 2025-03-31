resource "aws_instance" "test-ec2" {
  # ami           = "ami-076c6dbba59aa92e6" #data.aws_ami.ubuntu.id
  ami           = data.aws_ami.ubuntu.id
  instance_type = "t2.micro"
  associate_public_ip_address = true
  key_name = "DevOps"
  
  tags = {
    Name = "test-ec2"
  }
}