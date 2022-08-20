variable region {
    type    = string
    description = "Set this to the region to deploy resources. Ensure the region has at least three availiability zones"
    }

variable "vpc_id" {
    type = string
    description = "This is the id of the vpc created in the network module"
}

variable "eks_cluster_name" {
    description = "name of the eks cluster"
    type = string
}


variable "security_group_map" {
    type = map
    description = "The map of all the security groups for each tier."
}

variable "subnet_map"   {
    type = map
    description = "Map of all the vpc subnets"
}

variable "endpoint_subnet_id_list"   {
    type = list
    description = "List of private application subnets to add endpoints"
}



variable "private_route_table_id" {
    type = string
    description = "This is the route table for the private subnets"
}


variable "mongodbatlas_peering_connection_id" {
    type = string
    description = "VPC peering Connection ID for the MongoDB Atlas cluster"
}


variable "mongodb_cidr_block" {
    type = string
    description = "CIDR block of the MongoDB Atlas cluster"
}
