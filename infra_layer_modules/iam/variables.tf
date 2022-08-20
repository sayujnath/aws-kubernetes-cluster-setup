

variable "primary_domain_host_zone_id"  {
    type    = string
    description = "The name of the host zone file for the primary domain"
}

variable account_number {
    type = string
    default = ""
    description = "This is the number of the development account which owns the AMI that will be used"
}

variable region {
    type    = string
    description = "Set this to the region to deploy resources. Ensure the region has at least three availiability zones"
}

variable eks_cluster_name {
    description = "name of the eks cluster"
    type = string
}
