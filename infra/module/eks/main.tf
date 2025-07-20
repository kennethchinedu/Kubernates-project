


#-----------------------------------------------------------------------------------



#=----- EKS
resource "aws_iam_role" "eks-cluster-role" {
  name = "eks-cluster-role"
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
  role       = aws_iam_role.eks-cluster-role.name
}

resource "aws_eks_cluster" "demo-eks-cluster" {
  name     = "my_cluster2"
  role_arn = aws_iam_role.eks-cluster-role.arn
  vpc_config {
    endpoint_private_access = true
    endpoint_public_access  = true
    subnet_ids = [
      var.public_subnet_ids,
      var.private_subnet_ids

    ]
  }
  access_config {
    authentication_mode                         = "API"
    bootstrap_cluster_creator_admin_permissions = true
  }
  bootstrap_self_managed_addons = true

  version = "1.32"
  upgrade_policy {
    support_type = "STANDARD"
  }
  depends_on = [aws_iam_role_policy_attachment.eks_cluster_policy]
}




resource "aws_iam_role" "eks-ng-role" {
  name = "eks-node-group-role"

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

resource "aws_iam_role_policy_attachment" "eks-ng-WorkerNodePolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
  role       = aws_iam_role.eks-ng-role.name
}

resource "aws_iam_role_policy_attachment" "eks-ng-AmazonEKS_CNI_Policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
  role       = aws_iam_role.eks-ng-role.name
}

resource "aws_iam_role_policy_attachment" "eks-ng-ContainerRegistryReadOnly" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
  role       = aws_iam_role.eks-ng-role.name
}



#Launch Template for EKS Node Group

resource "aws_launch_template" "eks_node_group_lt" {
  name_prefix   = "eks-node-"
  # image_id      = "ami-xxxxxxxxxxxx" # EKS optimized AMI
  instance_type = "t2.micro"

  vpc_security_group_ids = [
    var.security_group_id
  ]

  key_name = "kube-demo" 

  lifecycle {
    create_before_destroy = true
  }
}


resource "aws_eks_node_group" "eks-node-group" {
  cluster_name    = "my_cluster2"
  node_role_arn   = aws_iam_role.eks-ng-role.arn
  node_group_name = "demo-eks-node-group"
  subnet_ids = [
    var.public_subnet_ids

  ]
  launch_template {
    id      = aws_launch_template.eks_node_group_lt.id
    version = "$Latest"
  }
  scaling_config {
    desired_size = 1
    max_size     = 4
    min_size     = 1
  }
  update_config {
    max_unavailable = 1
  }

  # remote_access {
  #   source_security_group_ids = [var.security_group_id]
    
  # }
  # Ensure that IAM Role permissions are created before and deleted after EKS Node Group handling.
  # Otherwise, EKS will not be able to properly delete EC2 Instances and Elastic Network Interfaces.
  depends_on = [
    aws_eks_cluster.demo-eks-cluster,
    aws_iam_role_policy_attachment.eks-ng-WorkerNodePolicy,
    aws_iam_role_policy_attachment.eks-ng-AmazonEKS_CNI_Policy,
    aws_iam_role_policy_attachment.eks-ng-ContainerRegistryReadOnly,
  ]
}