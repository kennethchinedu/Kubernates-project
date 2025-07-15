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

#using EKS module from terraform-aws-modules
# This module creates an EKS cluster with a single node group.

# module "eks" {
#   source  = "terraform-aws-modules/eks/aws"
#   version = "~> 20.37"

#   cluster_name    = "ek8s-cluster"
#   cluster_version = "1.31"

#   # Optional
#   cluster_endpoint_public_access = true

#   # Optional: Adds the current caller identity as an administrator via cluster access entry
#   enable_cluster_creator_admin_permissions = true

#   cluster_compute_config = {
#     enabled    = true
#     node_pools = ["general-purpose"]
#   }

#   vpc_id     = var.vpc_id
#   subnet_ids = ["var.private_subnet_ids"]

#   tags = merge(
#   local.common_tags,
#   { Name = "k8s" } )
# }



resource "aws_eks_cluster" "eks" {
  name = "my_cluster"

  access_config {
    authentication_mode = "API"
  }

  role_arn = aws_iam_role.cluster.arn
  version  = "1.32"

  vpc_config {
    subnet_ids = [
      var.private_subnet_ids,
      var.public_subnet_ids,
      
    ]
  } 


  # Ensure that IAM Role permissions are created before and deleted after the cluster
  depends_on = [
    aws_iam_role.cluster,
    aws_iam_role_policy_attachment.cluster_AmazonEKSClusterPolicy
  ]
}


# Iam role for EKS cluster
# This role is assumed by the EKS service to manage the cluster.
resource "aws_iam_role" "cluster" {
  name = "eks-cluster-role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "sts:AssumeRole",
          "sts:TagSession"
        ]
        Effect = "Allow"
        Principal = {
          Service = "eks.amazonaws.com"
        }
      },
    ]
  })

  
}

resource "aws_iam_role_policy_attachment" "cluster_AmazonEKSClusterPolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
  role       = aws_iam_role.cluster.name
}




# Creating a launch template for node group

resource "aws_launch_template" "eks_node_launch_template" {
  name_prefix   = "eks-node-launch-template-"
  image_id      = var.ami
  instance_type = var.instance_type
  key_name      = "kube-demo" 

  vpc_security_group_ids = [var.security_group_id]

  tag_specifications {
    resource_type = "instance"
    tags = {
      Name = "eks-node"
    }
  }
}

#-------------------------------------------
## Creating node group for EKS cluster

resource "aws_eks_node_group" "ek8s_node_group" {
  cluster_name    = aws_eks_cluster.eks.name
  node_group_name = "my_cluster_node_group"
  node_role_arn   = aws_iam_role.node_group_iam_role.arn
  subnet_ids      = [var.public_subnet_ids]

  scaling_config {
    desired_size = 1
    max_size     = 5
    min_size     = 1
  }

  launch_template {
    id      = aws_launch_template.eks_node_launch_template.id
    version = "$Latest"
  }

  update_config {
    max_unavailable = 2
  }


  depends_on = [
    aws_iam_role_policy_attachment.node-group-AmazonEKSWorkerNodePolicy,
    aws_iam_role_policy_attachment.node-group-AmazonEKS_CNI_Policy,
    aws_iam_role_policy_attachment.node-group-AmazonEC2ContainerRegistryReadOnly,
  ]
}




# IAM role for EKS Node Group
resource "aws_iam_role" "node_group_iam_role" {
  name = "node_group_iam_role"

  assume_role_policy = jsonencode({
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Principal = {
        Service = "ec2.amazonaws.com"
      }
    }]
    Version = "2012-10-17"
  })
}

resource "aws_iam_role_policy_attachment" "node-group-AmazonEKSWorkerNodePolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
  role       = aws_iam_role.node_group_iam_role.name
}

resource "aws_iam_role_policy_attachment" "node-group-AmazonEKS_CNI_Policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
  role       = aws_iam_role.node_group_iam_role.name
}

resource "aws_iam_role_policy_attachment" "node-group-AmazonEC2ContainerRegistryReadOnly" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
  role       = aws_iam_role.node_group_iam_role.name
}
