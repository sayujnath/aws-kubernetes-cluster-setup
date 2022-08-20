
# ############################## MONGODB ATLAS################################
# ############################### SUBNET PEERING #############################
# the following assumes an AWS provider is configured
# Accept the peering connection request
resource "aws_vpc_peering_connection_accepter" "atlas_peer" {
    vpc_peering_connection_id = var.mongodbatlas_peering_connection_id
    auto_accept = true
    lifecycle {
        ignore_changes = all
    }

    tags = {
        Name = "${var.eks_cluster_name}-mongodb-atlas-peer"
    }

}

resource "aws_route"  "mongodb_vpc_route"{
    route_table_id            = var.private_route_table_id
    destination_cidr_block    = var.mongodb_cidr_block
    vpc_peering_connection_id = var.mongodbatlas_peering_connection_id
    
}

resource "aws_vpc_peering_connection_options" "sb_vpc_peering_options" {
    vpc_peering_connection_id = aws_vpc_peering_connection_accepter.atlas_peer.id

    accepter {
        allow_remote_vpc_dns_resolution = true
    }

}