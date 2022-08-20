output "account_number" {
    value = var.account_number
}

output "aws_cli_profile" {
    value = var.aws_cli_profile
}

output "context_name" {
    value = module.eks_cluster.context_name
}

output "eks_oicd_connect_info" {
    value = module.eks_cluster.eks_oicd_connect_info
}

output "region" {
    value = var.region
}

output "vpc_id" {
    value = module.network.vpc.id
}

output "subnet_map" {
    value = module.network.subnet_map
}

output "security_group_map" {
    value = module.security.security_group_map
}

output "primary_domain" {
    value = var.primary_domain
}

output "primary_domain_host_zone_id" {
    value = var.primary_domain_host_zone_id
    
}

output "client" {
    value = var.client
}

output "client_subdomain" {
    value = var.client_subdomain
}


output "default_tags" {
    value = var.default_tags
    
}

output "cloudwatch_log_retention"   {
    value = var.cloudwatch_log_retention
    description = "Number of days cloudwatch logs will retain data"
}

output "ecr_image_location"   {
    value = var.ecr_image_location
    description = "Location of regional ecr image for the example service"
}

output "health_check_path"    {
    value = var.health_check_path
    description = "The path parameters of the healh check endpoint"
}

output "database_connection_string" {
    value = nonsensitive(module.mongodb_vpc_peer.database_connection_string)
    description = "The connection url to the MongoDB Database"
    sensitive = false
}


output "pod_env_variables"    {
    value = var.pod_env_variables
    description = "The environmental variables used when launching the pod"
}

output waf_rules_arn    {
    value = module.waf.waf_rules_arn
}

output acm_certificate_arn {
    value = module.acm_certificate.acm_certificate_arn
}