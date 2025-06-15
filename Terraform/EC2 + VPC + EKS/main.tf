# Deploy VPC
# module "aws_vpc" {
#   source = "./modules/vpc"

#   vpc_name    = "test_vpc"
#   enable_ipv6 = true
#   create_igw  = true
#   # public_subnet      = 2
#   enable_NAT_gateway = false
#   # number of public subnets?
#   # number if private subnets?
#   # public subnets required?
#   # private subnets required?
#   # public and database subnet CIDR range?
# }

# Deploy EC2 Instance
# module "ec2_instance" {
#   source = "./modules/ec2"


#   ec2_name          = "Terraform_instance"
#   ami_id            = "ami-0e35ddab05955cf57" # fetch with data source
#   sg_name           = "default_sg_ec2"
#   ec2_instance_name = "t2.micro"
#   ec2_pem_file      = "DevOps"
#   ec2_az            = data.aws_availability_zones.available_1.names[0]
#   vpc_id            = module.aws_vpc.vpc_id
#   enable_port_80    = 80
#   subnet_id         = module.aws_vpc.public_subnet_1
#   vpc_sg_id         = module.aws_vpc.sg

# }

# # Deploy EKS Cluster and Node Group
# module "eks_cluster" {
#   source = "./modules/eks"

#   eksclustername        = "test_eks_cluster"
#   vpc_id                = module.aws_vpc.vpc_id
#   subnet1               = module.aws_vpc.public_subnet_1
#   subnet2               = module.aws_vpc.public_subnet_2
#   nodegroupname         = "test_eks_node_group"
#   numberofNodes         = 2
#   NodeGroupInstanceType = "t2.micro"
#   numberofmaxNodes      = 3
#   numberofminNodes      = 1
#   max_unavailable       = 2
# }


# TEST
# module "ec2-instance" {
#   source  = "terraform-aws-modules/ec2-instance/aws"
#   version = "5.8.0"
  
  
#     name = "anuj-my-instance"
#     ami  = "ami-0e35ddab05955cf57" # fetch with data source
#     instance_type = "t2.micro"
#     key_name      = "DevOps"
#     availability_zone = data.aws_availability_zones.available_1.names[0]
#     associate_public_ip_address = true

# }

module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "5.19.0"

  name = "my-vpc"
  cidr = "10.0.0.0/16"

  azs             = [data.aws_availability_zones.available_1.names[0], data.aws_availability_zones.available_1.names[1]]
  private_subnets = ["10.0.1.0/24", "10.0.2.0/24"]
  public_subnets  = ["10.0.101.0/24", "10.0.102.0/24"]

  enable_nat_gateway = true
  tags = {
    Terraform = "true"
    Environment = "dev"
  }
}