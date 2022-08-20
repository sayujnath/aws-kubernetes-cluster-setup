

variable "aws_cli_profile"    {
    type    = string
    description = "The name of the aws cli profile on localhost used to access aws account resources "
}

variable region {
    type    = string
    description = "The region for this deployment" 
}

variable "eks_cluster_name" {
    description = "name of the eks cluster"
    type = string
}

variable "eks_version" {
    description = "The version Kubernestes for the EKS cluster"
}


variable "security_group_map" {
    type = map
    description = "The map of all the security groups for each tier."
}

variable "subnet_map"   {
    type = map
    description = "Map of all the vpc subnets"
}


variable "example_eks_cluster_role_arn"    {
    type = string
    description = "The role used by the EKS cluster to manage resources"
}

variable "eks_worker_instance_profile_name" {
    type = string
    description = "The instance profile needed by the eks cluster to configure eks nodes"
}

variable "node_instance_type" {
    type = string
    description = "The type of EC2 instance to be used by the node"
}

variable "eks_worker_role_arn" {
    type = string
    description = "The role needed by the eks cluster to configure eks nodes"
}


variable default_tags   {
    type    = map
    description = "Tags that designame ownership and association with this resource"
}


variable "cloudwatch_log_retention"   {
    type = number
    description = "Number of days cloudwatch logs will retain data"
}

variable "node_scaling_config" {
    type = map(number)
    description = "Map with the min, max and desired number of nodes in the cluster for cluster auto-scaling"
}