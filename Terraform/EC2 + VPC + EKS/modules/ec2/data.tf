# data "aws_ami" "ubuntu" {
#   most_recent = true
#   # owners = ["ubuntu"] # Canonical

#   # filter {
#   #   name   = "name"
#   #   values = ["al2023-ami-*-x86_64"]
#   # }

#   filter {
#     name   = "virtualization-type"
#     values = ["hvm"]
#   }
#   filter {
#     name = "root-device-type"
#     values = ["ebs"]
#   }
#   filter {
#     name = "architecture"
#     values = ["x86_64"]
#   }
#   filter {
#     name = "description"
#     values = ["Canonical, Ubuntu, 24.04, amd64 noble image"]
#   }
# }