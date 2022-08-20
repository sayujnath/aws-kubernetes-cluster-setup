output example_eks_cluster_role_arn {
    value = aws_iam_role.example-cluster-role.arn
    description = "The role needed by the eks cluster to configure eks nodes"
}

output eks_worker_instance_profile_name {
    value = aws_iam_instance_profile.eks_worker_instance_profile.name
    description = "The instance profile needed by the eks cluster to configure eks nodes"
}

output eks_worker_role_arn {
    value = aws_iam_role.eks_worker_role.arn
    description = "The role needed by the eks cluster to configure eks nodes"
}