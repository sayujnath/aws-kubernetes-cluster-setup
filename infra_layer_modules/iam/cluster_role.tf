######################################################################################

#   Title:          Example   App AWS cloud resources
#   Author:         Sayuj Nath, Cloud Solutions Architect
#   Comapany:       Canditude
#                   Prepared for  public non-commercial use
#   Description:    Computing resources for
#                   development and deployment using AWS
#                   public cloud resources.
#   File Desc:      IAM role and policy to allow the EKS service to manage or #     #                   retrieve data from other AWS services.

#######################################################################################

locals {
    iam_policy_path =  "${path.module}/../../iam_policies"
}


resource "aws_iam_role" "example-cluster-role" {
  name = "${var.eks_cluster_name}-eks-cluster-role"

  assume_role_policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "eks.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
POLICY
}

resource "aws_iam_role_policy_attachment" "example-eks-cluster-AmazonEKSClusterPolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
  role       = aws_iam_role.example-cluster-role.name
}

resource "aws_iam_role_policy_attachment" "example-eks-cluster-AmazonEKSServicePolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSServicePolicy"
  role       = aws_iam_role.example-cluster-role.name
}

resource "aws_iam_role_policy_attachment" "example-eks-cluster-AmazonEKSVPCResourceController" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSVPCResourceController"
  role       = aws_iam_role.example-cluster-role.name
}


resource "aws_iam_role_policy_attachment" "example-eks-cluster-ecr-rw" {
  policy_arn = aws_iam_policy.example_ecr_rw.arn
  role       = aws_iam_role.example-cluster-role.name
}

resource "aws_iam_role_policy_attachment" "example-eks-cluster-web-report-rw" {
  policy_arn = aws_iam_policy.example_web_report_rw.arn
  role       = aws_iam_role.example-cluster-role.name
}

resource "aws_iam_role_policy_attachment" "example-eks-cluster-alb-ingress-controller-role-policy" {
  policy_arn = aws_iam_policy.example_cluster_role_alb_ingress_controller_role_policy.arn
  role       = aws_iam_role.example-cluster-role.name
}

resource "aws_iam_policy" "example_ecr_rw" {
    name = "${var.eks_cluster_name}-ecr-rw"
    description = "This policy the example EKS cluster to read ECR images"
    policy = templatefile("${local.iam_policy_path}/example-ecr-rw.json",{region = var.region, account_number = var.account_number})
}


resource "aws_iam_policy" "example_web_report_rw" {
    name = "${var.eks_cluster_name}-web-report-rw"
    description = "This policy gives the example EKS cluster ability to read S3 bucket  example-webreport-sw-talla"
    policy = file("${local.iam_policy_path}/example_web_report_rw.json")
}

//TODO - DELETE IF NOT REQUIRED
resource "aws_iam_policy" "example_cluster_role_alb_ingress_controller_role_policy" {
    name = "${var.eks_cluster_name}-example-cluster-role-alb-ingress-controller-role-policy"
    description = "This policy gives the example EKS cluster ability to create and destroy ALB ingres resources as well as add DNS records in route 53"
    policy =  file("${local.iam_policy_path}/example_alb_ingress_controller_role_policy.json")
}