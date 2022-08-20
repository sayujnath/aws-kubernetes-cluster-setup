######################################################################################

#   Title:          Example   App AWS cloud resources
#   Author:         Sayuj Nath, Cloud Solutions Architect
#   Comapany:       Canditude
#                   Prepared for  public non-commercial use
#   Description:    Computing resources for
#                   development and deployment using AWS
#                   public cloud resources.
#   File Desc:       Variables to pass to main_setup, which will create overall
#                   and infrastructure with all environments 
#
#   Variables:  
#                   - region               Region of deployment
#                   - type                 will this infrastructure be used in development, staging or production
#                   - vpc_name_pfx         ID of main vpc
#                   - cidr_block:          CIDR block of main vpc

#######################################################################################

variable account_number {
    type = string
    description = "This is the number of the development account which owns the AMI that will be used"
}

variable region {
    type    = string
    description = "Set this to the region to deploy resources. Ensure the region has at least three availiability zones"
}


variable default_tags   {
    type    = map
    description = "Tags that designame ownership and association with this resource"
}


variable cidr_block {
    type    = string
    default = "0.0.0.0/0"
    description = "This will the CIDR block of the application VPC."
}


variable aws_cli_profile    {
    type    = string
    description = "The name of the aws cli profile on localhost used to access aws account resources "
}

variable deployment_name    {
    type = string
    description = "A unique name for this deployment. All created resources will use this name as a prefix"
}

variable "client" {
    type = string
    description = "A unique identifier of the application in the deployment. This will be also used in the subdomain i.e <client>.api.sgp. exampleexample.com.au"
  
}

variable "client_subdomain" {
    type = string
    description = "A unique subdomain of the application in the deployment. This will be also used in the domain i.e <client_subdomain>. exampleexample.com.au"
  
}

variable "primary_domain_host_zone_id"  {
    type    = string
    description = "The name of the host zone file for the primary domain"
}

variable "primary_domain" {
    type    = string
    description = "The root domain name of the format application server"
}

variable "ecr_image_location"   {
    type = string
    description = "Location of regionsal ecr image for the example service"
}

variable "health_check_path"    {
    type = string
    description = "The path parameters of the healh check endpoint"
}

variable "cloudwatch_log_retention"   {
    type = number
    description = "Number of days cloudwatch logs will retain data"
}

variable "mongodb_project_info" {
    type = map
    description = "Information to connect to MongoDB ATLAS infrastructure of specific project"
}

variable "pod_env_variables"    {
    type = map
    description = "The environmental variables used when launching the pod"
}