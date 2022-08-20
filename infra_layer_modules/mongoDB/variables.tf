

variable aws_account_number {
    type = string
    default = ""
    description = "This is the number of the development account which owns the AMI that will be used"
}

variable "aws_region" {
    type    = string
    description = "Set this to the region to deploy resources. Ensure the region has at least three availiability zones."
}

variable "eks_cluster_name" {
    description = "name of the eks cluster"
    type = string
}


variable "vpc_id" {
    type = string
    description = "This is the id of the vpc created in the network module"
}

variable "vpc_cidr_block" {
    type    = string
    description = "This will the CIDR block of the application VPC."
}


variable "mongodb_cidr_block" {
    type    = string
    description = "This will the CIDR block of the MongoDB ATLAS VPC."
}


variable "mongodb_credentials" {
    type = map
    description = "Map containing private and public keys for accessing MogoDB provider via API"
} 

variable "mongodb_cluster_base_url" {
    description = "Atlas project ID"
}


variable "atlasprojectid" {
    description = "Atlas project ID"
}


variable "eks_worker_role_arn" {
    type = string
    description = "The role needed by the eks cluster to configure eks nodes. This is used to create IAM credentials."
}