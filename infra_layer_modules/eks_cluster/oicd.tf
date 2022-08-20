#                   This version of the code is incomplete &untested and specially released 
#                   for non-commecial public consumption. 

#                   For a production ready version,
#                   please contact the author at info@canditude.com
#                   Additional middleware is also required in application code to interact
#                   with the authorizaion servers 
data "tls_certificate" "tls-cert" {
    url = aws_eks_cluster.eks-cluster-example.identity[0].oidc[0].issuer
}

resource "aws_iam_openid_connect_provider" "oicd-eks-connect" {
    client_id_list  = ["sts.amazonaws.com"]
    thumbprint_list = [data.tls_certificate.tls-cert.certificates[0].sha1_fingerprint]
    url             = aws_eks_cluster.eks-cluster-example.identity[0].oidc[0].issuer

    tags = {
        "alpha.eksctl.io/cluster-name" = aws_eks_cluster.eks-cluster-example.name
        "alpha.eksctl.io/eksctl-version" = "0.88.0"
    }
}