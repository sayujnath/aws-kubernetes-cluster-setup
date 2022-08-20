
####################### CLOUDWATCH VPC  INTERFACE #########################
############################### ENDPOINT ##################################

resource "aws_vpc_endpoint" "cloudwatch_endpoint" {
    vpc_id            = var.vpc_id
    service_name      = "com.amazonaws.${var.region}.monitoring"
    vpc_endpoint_type = "Interface"

    security_group_ids = [
        var.security_group_map.web.id,
        var.security_group_map.app.id,
    ]
    
    subnet_ids = var.endpoint_subnet_id_list

    private_dns_enabled = true
    tags = {
        Name = "${var.eks_cluster_name}-vpc-cloudwatch-interface"
    }
}
