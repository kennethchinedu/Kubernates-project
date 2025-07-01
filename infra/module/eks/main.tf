#Provisioning ec2 as bastion host
# module "ec2_instance" {
#   source  = "terraform-aws-modules/ec2-instance/aws"

#   name = "single-instance"

#   instance_type = "t2.micro"
#   key_name      = "user1"
#   monitoring    = true
#   subnet_id     = "subnet-eddcdzz4"

#    tags = merge(
#   local.common_tags,
#   { Name = "public-subnet" } )

# }


module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 20.37"

  cluster_name    = "ek8s-cluster"
  cluster_version = "1.31"

  # Optional
  cluster_endpoint_public_access = true

  # Optional: Adds the current caller identity as an administrator via cluster access entry
  enable_cluster_creator_admin_permissions = true

  cluster_compute_config = {
    enabled    = true
    node_pools = ["general-purpose"]
  }

  vpc_id     = var.vpc_id
  subnet_ids = ["var.private_subnet_ids"]

  tags = merge(
  local.common_tags,
  { Name = "k8s" } )
}

