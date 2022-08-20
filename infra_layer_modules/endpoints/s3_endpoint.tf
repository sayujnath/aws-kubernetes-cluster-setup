
############################## S3 GATEWAY ################################
############################### ENDPOINT #################################

# This gateway endpoint gives provides private access from private subnets
# to S3 buckets where files are stored.
resource "aws_vpc_endpoint" "s3_endpoint" {
    vpc_id       = var.vpc_id
    service_name = "com.amazonaws.${var.region}.s3"

    tags = {
        Name = "${var.eks_cluster_name}-vpc-s3-gateway"
    }
}

resource "aws_vpc_endpoint_route_table_association" "s3_endpoint_route" {
    route_table_id  = var.private_route_table_id
    vpc_endpoint_id = aws_vpc_endpoint.s3_endpoint.id
}