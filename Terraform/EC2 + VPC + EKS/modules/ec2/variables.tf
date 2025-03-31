variable "ami_id" {
  type        = string
  default     = "ami-0e35ddab05955cf57"
  description = "The AMI ID to use for the EC2 instance. This should be a valid AMI ID in the region where you're deploying."
}

variable "sg_name" {
  type    = string
  default = "default_sg_ec2"
}

#
# Optional
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
#
#
