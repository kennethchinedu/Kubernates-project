



output "eks_node_group_name" {
  value = aws_eks_node_group.eks-node-group.node_group_name
}

output "eks_node_group_id" {
  value = aws_eks_node_group.eks-node-group.id
}

