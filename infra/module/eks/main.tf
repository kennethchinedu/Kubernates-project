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



#-----------------------------------------------------------------------------------------------
# Iam role for EKS cluster
# This role is assumed by the EKS service to manage the cluster.
# resource "aws_iam_role" "cluster" {
#   name = "eks-cluster-role"
#   assume_role_policy = jsonencode({
#     Version = "2012-10-17"
#     Statement = [
#       {
#         Action = [
#           "sts:AssumeRole",
#           "sts:TagSession"
#         ]
#         Effect = "Allow"
#         Principal = {
#           Service = "eks.amazonaws.com"
#         }
#       },
#     ]
#   })
# }


# #Attaching the AmazonEKSClusterPolicy to the EKS cluster IAM role
# resource "aws_iam_role_policy_attachment" "cluster_AmazonEKSClusterPolicy" {
#   policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
#   role       = aws_iam_role.cluster.name
# }


# resource "aws_eks_cluster" "eks" {
#   name = "my_cluster"

#   role_arn = aws_iam_role.cluster.arn
#   version  = "1.32"

#   access_config {
#     authentication_mode = "API"
#     bootstrap_cluster_creator_admin_permissions = true
#   }

#   bootstrap_self_managed_addons = true

#   vpc_config {
#     endpoint_private_access = true
#     endpoint_public_access  = true
#     subnet_ids = [
#       var.private_subnet_ids,
#       var.public_subnet_ids,
      
#     ] 
#   } 

#   # Ensuring that IAM Role permissions are created before and deleted after the cluster
#   depends_on = [
#     aws_iam_role.cluster,
#     aws_iam_role_policy_attachment.cluster_AmazonEKSClusterPolicy
#   ]
# }







# # Creating a launch template for node group

# resource "aws_launch_template" "eks_node_launch_template" {
#   name_prefix   = "eks-node-launch-template-"
#   image_id      = var.ami
#   instance_type = var.instance_type
#   key_name      = "kube-demo" 

#   vpc_security_group_ids = [var.security_group_id]

#   tag_specifications {
#     resource_type = "instance"
#     tags = {
#       Name = "eks-node"
#     }
#   }
# }

# # IAM role for EKS node group
# # IAM role for EKS Node Group
# resource "aws_iam_role" "node_group_iam_role" {
#   name = "node_group_iam_role"

#   assume_role_policy = jsonencode({
#     Statement = [{
#       Action = "sts:AssumeRole"
#       Effect = "Allow"
#       Principal = {
#         Service = "ec2.amazonaws.com"
#       }
#     }]
#     Version = "2012-10-17"
#   })
# }


# # Attaching policies to the EKS Node Group IAM role
# resource "aws_iam_role_policy_attachment" "node-group-AmazonEKSWorkerNodePolicy" {
#   policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
#   role       = aws_iam_role.node_group_iam_role.name
# }

# resource "aws_iam_role_policy_attachment" "node-group-AmazonEKS_CNI_Policy" {
#   policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
#   role       = aws_iam_role.node_group_iam_role.name
# }

# resource "aws_iam_role_policy_attachment" "node-group-AmazonEC2ContainerRegistryReadOnly" {
#   policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
#   role       = aws_iam_role.node_group_iam_role.name
# }


# #-------------------------------------------
# ## Creating node group for EKS cluster

# resource "aws_eks_node_group" "ek8s_node_group" {
#   cluster_name    = aws_eks_cluster.eks.name
#   node_group_name = "my_cluster_node_group"
#   node_role_arn   = aws_iam_role.node_group_iam_role.arn
#   subnet_ids      = [var.public_subnet_ids]

#   scaling_config {
#     desired_size = 1
#     max_size     = 5
#     min_size     = 1
#   }

#   launch_template {
#     id      = aws_launch_template.eks_node_launch_template.id
#     version = "$Latest"
#   }

#   update_config {
#     max_unavailable = 2
#   }


#   depends_on = [
#     aws_iam_role.node_group_iam_role,
#     aws_iam_role_policy_attachment.node-group-AmazonEKSWorkerNodePolicy,
#     aws_iam_role_policy_attachment.node-group-AmazonEKS_CNI_Policy,
#     aws_iam_role_policy_attachment.node-group-AmazonEC2ContainerRegistryReadOnly,
#   ]
# }






#-----------------------------------------------------------------------------------

#=----- EKS
resource "aws_iam_role" "demo-eks-cluster-role" {
name = "demo-eks-cluster-role"
assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
    {
        Action = [
        "sts:AssumeRole",
        ]
        Effect = "Allow"
        Principal = {
        Service = "eks.amazonaws.com"

        }
    },
    ]
})
}

resource "aws_iam_role_policy_attachment" "eks_cluster_policy" {
policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
role       = aws_iam_role.demo-eks-cluster-role.name
}

resource "aws_eks_cluster" "demo-eks-cluster" {
    name = "my_cluster2"
    role_arn = aws_iam_role.demo-eks-cluster-role.arn
    vpc_config {
    endpoint_private_access = true
    endpoint_public_access = true
    subnet_ids = [
        var.public_subnet_ids ,
        var.private_subnet_ids
        
    ]
    }
    access_config {
    authentication_mode = "API"
    bootstrap_cluster_creator_admin_permissions = true
    }
    bootstrap_self_managed_addons = true
    
    version = "1.32"
    upgrade_policy {
    support_type = "STANDARD"
    }
    depends_on = [ aws_iam_role_policy_attachment.eks_cluster_policy ]
}




resource "aws_iam_role" "demo-eks-ng-role" {
name = "demo-eks-node-group-role"

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

resource "aws_iam_role_policy_attachment" "eks-demo-ng-WorkerNodePolicy" {
policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
role       = aws_iam_role.demo-eks-ng-role.name 
}

resource "aws_iam_role_policy_attachment" "eks-demo-ng-AmazonEKS_CNI_Policy" {
policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
role       = aws_iam_role.demo-eks-ng-role.name 
}

resource "aws_iam_role_policy_attachment" "eks-demo-ng-ContainerRegistryReadOnly" {
policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
role       = aws_iam_role.demo-eks-ng-role.name 
}

resource "aws_eks_node_group" "eks-demo-node-group" {
cluster_name    = "my_cluster2"
node_role_arn   = aws_iam_role.demo-eks-ng-role.arn
node_group_name = "demo-eks-node-group"
subnet_ids      = [
    var.public_subnet_ids
  
    ]
scaling_config {
    desired_size = 1
    max_size     = 4
    min_size     = 1
}
update_config {
    max_unavailable = 1
}

# Ensure that IAM Role permissions are created before and deleted after EKS Node Group handling.
# Otherwise, EKS will not be able to properly delete EC2 Instances and Elastic Network Interfaces.
depends_on = [
    
    aws_iam_role_policy_attachment.eks-demo-ng-WorkerNodePolicy,
    aws_iam_role_policy_attachment.eks-demo-ng-AmazonEKS_CNI_Policy,
    aws_iam_role_policy_attachment.eks-demo-ng-ContainerRegistryReadOnly,
]
}