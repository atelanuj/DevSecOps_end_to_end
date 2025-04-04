# Deploy EC2 Instance
module "ec2_instance" {
  source            = "./modules/ec2"
  ec2_name          = "Terraform_instance"
  ami_id            = "ami-0e35ddab05955cf57"
  sg_name           = "default_sg_ec2"
  ec2_instance_name = "t2.micro"
  ec2_pem_file      = "DevOps"
  ec2_az            = "ap-south-1b"
  enable_port_80    = 80

}

# # Deploy VPC
module "aws_vpc" {
  source = "./modules/vpc"

}

# Deploy EKS Cluster and Node Group
module "eks_cluster" {
  source = "./modules/eks"


  eksclustername = "test_eks_cluster"
  vpc_id                = module.aws_vpc.vpc_id
  subnet1               = module.aws_vpc.subnet1_id
  subnet2               = module.aws_vpc.subnet2_id
  nodegroupname         = "test_eks_node_group"
  numberofNodes         = 2
  NodeGroupInstanceType = "t2.micro"
  numberofmaxNodes      = 3
  numberofminNodes      = 1
  max_unavailable       = 2


}

