output "eks_oicd_connect_info" {
    value = {
        eks_cluster_name = aws_eks_cluster.eks-cluster-example.name
        issuer_url = aws_eks_cluster.eks-cluster-example.identity[0].oidc[0].issuer
        openid_connect_url = aws_iam_openid_connect_provider.oicd-eks-connect.url
        openid_connect_arn = aws_iam_openid_connect_provider.oicd-eks-connect.arn
    }
}

output context_name {
    value = local.context_name
    
}