output "mongodbatlas_peering_connection_id" {
    value = mongodbatlas_network_peering.mongodb_peer.connection_id
    description = "VPC peering Connection ID for the MongoDB Atlas cluster"
}

output "database_connection_string" {
    value = base64encode("mongodb+srv://${var.eks_cluster_name}:${random_password.example_db_prod_pwd.result}@${var.mongodb_cluster_base_url}")
    description = "The connection url to the MongoDB Database"
}