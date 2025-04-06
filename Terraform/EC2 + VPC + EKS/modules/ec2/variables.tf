#
# EC2 vars
#
variable "ami_id" {
  type        = string
  default     = "ami-0e35ddab05955cf57"
  description = "The AMI ID to use for the EC2 instance. This should be a valid AMI ID in the region where you're deploying."
}
variable "sg_name" {
  type    = string
  default = "default_sg_ec2"
}
variable "ec2_instance_name" {
  type    = string
  default = "t2.micro"
}
variable "ec2_pem_file" {
  type    = string
  default = "DevOps"
}
variable "ec2_az" {
  type    = string
  default = "ap-south-1a"
}
variable "ec2_name" {
  type    = string
  default = "my_ec2_instance"
  description = "The name of the EC2 instance."
}
#
# VPC vars
#
variable "subnet_id" {
  type    = string
  default = null
  description = "The name of the subnet_id"
}
variable "vpc_id" {
  type    = string
  default = null
  description = "The name of the vpc_id"
}
variable "vpc_sg_id" {
  type    = string
  default = null
  description = "The name of the vpc_sg_id"
}

#
# Port Seletion
#
variable "enable_port_22" {
  type        = number
  default     = 22
  description = "Enable SSH port 22 for the EC2 instance."
}

variable "enable_port_80" {
  type        = number
  default     = 80
  description = "Enable SSH port 22 for the EC2 instance."
}

variable "enable_port_443" {
  type        = number
  default     = 443
  description = "Enable SSH port 22 for the EC2 instance."
}
#
# EBC vars
#
variable "ebs_az" {
  type        = string
  default     = "ap-south-1a"
  description = "The availability zone for the EBS volume."
}
variable "ebc_size" {
  type        = number
  default     = 15
  description = "The Size of EBS volume."
}
variable "ebs_type" {
  type        = string
  default     = "gp3"
  description = "The type of EBS volume."
}
variable "ebs_iops" {
  type        = number
  default     = 3000
  description = "The IOPS of EBS volume."
}
variable "ebs_throughput" {
  type        = number
  default     = 125
  description = "The throughput of EBS volume."
}
variable "ebs_mount_path" {
  type        = string
  default     = "/dev/nvme1n1"
  description = "The mount_path of EBS volume."
}