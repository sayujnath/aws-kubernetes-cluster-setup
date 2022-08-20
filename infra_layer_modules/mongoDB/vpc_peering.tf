# Create the peering connection request to the prod vpc
resource "mongodbatlas_network_peering" "mongodb_peer" {
    accepter_region_name   = var.aws_region
    project_id             = var.atlasprojectid
    container_id           = data.mongodbatlas_network_containers.mongodb_container_list.results[0].id
    provider_name          = "AWS"
    route_table_cidr_block = var.vpc_cidr_block
    vpc_id                 = var.vpc_id
    aws_account_id         = var.aws_account_number
    lifecycle {
        ignore_changes = all
    }
    
}

//adds the AWS example vpc cidr block as a whitelist to the ATLAS project
data "mongodbatlas_network_containers" "mongodb_container_list" {
    project_id     = var.atlasprojectid
    provider_name  ="AWS"
}

resource "mongodbatlas_project_ip_access_list" "aws_vpc_mongodb_whitelist" {
  project_id = var.atlasprojectid
  cidr_block = var.vpc_cidr_block
  comment    = "cidr block for allowing AWS example eks clster VPC to mongodb - from app tier"
}


