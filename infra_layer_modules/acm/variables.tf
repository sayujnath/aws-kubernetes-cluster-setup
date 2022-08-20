variable eks_oicd_connect_info  {
    type = map
    description = "This information is used to connect the OICD providor with EKS for K8S service accounts. The format of this is a follows {eks_cluste_rname, thumbprint, issuer_url}"
}


variable "primary_domain" {
    type    = string
    description = "The root domain name of the example api application server"
}

variable  "primary_domain_host_zone_id" {
    type = string
    description = "This is the zone ID of the host zone for the domain"
}

variable "api_subdomain"  {
    type    = string
    description = "The subdomain to be used with the primary domain"
}