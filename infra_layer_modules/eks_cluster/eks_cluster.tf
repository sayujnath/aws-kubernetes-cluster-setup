######################################################################################

#   Title:          Example   App AWS cloud resources
#   Author:         Sayuj Nath, Cloud Solutions Architect
#   Comapany:       Canditude
#                   Prepared for  public non-commercial use
#   Description:    Computing resources for
#                   development and deployment using AWS
#                   public cloud resources.
#   File Desc:      VPC setup for the example network
#                   deploys the following rsources:
#                   - VPC 
#                   - Internet gateway
#                   - Private and public routables

#                   Please see subnets.tf for subnet and routing information

#                   This version of the code is incomplete &untested and specially released 
#                   for non-commecial public consumption. 

#                   For a production ready version,
#                   please contact the author at info@canditude.com
#                   Additional middleware is also required in application code to interact
#                   with the authorizaion servers 

#######################################################################################

locals {

  context_name = var.eks_cluster_name   //cluster name is also the context name
}

resource "aws_cloudwatch_log_group" "eks_cluster_log" {
  # The log group name format is /aws/eks/<cluster-name>/cluster
  # Reference: https://docs.aws.amazon.com/eks/latest/userguide/control-plane-logs.html
  name              =  "/aws/eks/${local.context_name}/cluster"
  retention_in_days = var.cloudwatch_log_retention
}

resource "aws_eks_cluster" "eks-cluster-example" {

  depends_on = [ aws_cloudwatch_log_group.eks_cluster_log ]
  name            = local.context_name
  role_arn        = var.example_eks_cluster_role_arn

  version = var.eks_version  

  vpc_config {
    endpoint_private_access = false
    endpoint_public_access  = true
    security_group_ids = [var.security_group_map.eks.id]
    subnet_ids         = [var.subnet_map.eks.A.id, var.subnet_map.eks.B.id]   # add EKS nodes in AZ A and AZ B in app tier
  }

  # kubernetes_network_config {
  #     service_ipv4_cidr = var.cidr_block
  #     ip_family = "ipv4"

  # }

  enabled_cluster_log_types = ["api","audit","authenticator","controllerManager","scheduler"]   # enable logging of EKS control plane api calls

}
