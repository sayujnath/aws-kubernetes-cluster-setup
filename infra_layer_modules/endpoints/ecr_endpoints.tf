#                   This version of the code is incomplete &untested and specially released 
#                   for non-commecial public consumption. 

#                   For a production ready version,
#                   please contact the author at info@canditude.com
#                   Additional middleware is also required in application code to interact
#                   with the authorizaion servers 

// Image Security recommendations: https://aws.github.io/aws-eks-best-practices/security/docs/image/
########################### ECR VPC INTERFACE #########################
############################## ENDPOINT ##################################
resource "aws_vpc_endpoint" "ecr_dkr_endpoint" {
    vpc_id            = var.vpc_id
    service_name      = "com.amazonaws.${var.region}.ecr.dkr"

    vpc_endpoint_type = "Interface"

    security_group_ids = [  var.security_group_map.app.id]
    subnet_ids = [ var.subnet_map.app.A.id, var.subnet_map.app.B.id]

    private_dns_enabled = true
    tags = {
        Name = "${var.eks_cluster_name}-ecr-dkr-interface"
    }
}
    
resource "aws_vpc_endpoint" "ecr_api_endpoint" {
    vpc_id            = var.vpc_id
    service_name      = "com.amazonaws.${var.region}.ecr.api"

    vpc_endpoint_type = "Interface"

    security_group_ids = [  var.security_group_map.app.id]
    subnet_ids = [ var.subnet_map.app.A.id, var.subnet_map.app.B.id]

    private_dns_enabled = true
    tags = {
        Name = "${var.eks_cluster_name}-ecr-api-interface"
    }
}
