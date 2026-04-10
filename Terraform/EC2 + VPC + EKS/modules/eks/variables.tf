variable "eksclustername" {
  type    = string
  default = "my-eks-cluster"
}

variable "vpc_id" {
  type    = string
  default = ""
}

variable "subnet1" {
  description = "Default Subnet 1"
  type        = string
  default     = ""
}

variable "subnet2" {
  description = "Default Subnet 2"
  type        = string
  default     = ""
}
#
# Node Group variabels
#
variable "nodegroupname" {
  type    = string
  default = "my-eks-node-group"
}

variable "numberofNodes" {
  type    = number
  default = 2
}

variable "numberofmaxNodes" {
  type    = number
  default = 3
}

variable "numberofminNodes" {
  type    = number
  default = 1
}

variable "max_unavailable" {
  type    = number
  default = 2
}

variable "NodeGroupInstanceType" {
  type    = string
  default = "t2.micro"
}