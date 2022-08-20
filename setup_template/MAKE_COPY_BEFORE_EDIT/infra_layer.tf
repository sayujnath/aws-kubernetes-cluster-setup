######################################################################################

#   Title:          Example   App AWS cloud resources
#   Author:         Sayuj Nath, Cloud Solutions Architect
#   Comapany:       Canditude
#                   Prepared for  public non-commercial use
#   Description:    Computing resources for
#                   development and deployment using AWS
#                   public cloud resources.
#   File Desc:      The main setup for the  infrasructure layer which 
#                   deploys the following modules:
#                   - Networing 
#                   - Security
#                   - Kubernestes Cluster
#                   - Endpoints
#                   - Monitoring

# The following resources are managed via Kubernetes manifests, not Terraform
# This was done to repurpose existing technical debt.
#               - Application Load Balancer
#               - Application traffic routing
#               - Target groups
#               - DNS records with Rout 53
#               - IAM service accounts

#######################################################################################

locals   {
    k8s_cluster_name = "${var.deployment_name}-main"
    eks_version = "1.21"        // DO NOT UPGRADE UNLESS COMPATIBLE POD APPS, SUCH AS  Load Balalancer Controller, External-DNS ARE ALSO UPGRADED and TESTED WITH NEW K8S VERSION.
    node_instance_type = "t3.medium"
    node_scaling_config = {
        min = 1
        max = 5
        desired = 3
    }
}



module "network"    {
    source = "./../../infra_layer_modules/network"

    vpc_name = local.k8s_cluster_name
    cidr_block = var.cidr_block
    k8s_cluster_name = local.k8s_cluster_name

}


// Calls the Security Module
// this creates all the security groups needed
// to control traffic going into the VPC network ports
// uses security groups and Network ACLs
module "security" {
    source = "./../../infra_layer_modules/security"
    depends_on = [module.network]

    vpc_id = module.network.vpc.id
    subnet_map = module.network.subnet_map
    k8s_cluster_name = local.k8s_cluster_name
    app_service_ports = [tonumber(var.pod_env_variables.PORT),tonumber(var.pod_env_variables.PORT) + 1]
    mongodb_cidr_block = var.mongodb_project_info.mongodb_cidr_block
    vpc_cidr_block = var.cidr_block

}


module "iam"    {
    source = "./../../infra_layer_modules/iam"
    account_number = var.account_number
    region = var.region
    primary_domain_host_zone_id = var.primary_domain_host_zone_id

    eks_cluster_name = local.k8s_cluster_name
}


//creates a networking peer to MongoDB ATLAS to keep data secure
// creates a user and connection string tp connect with database.
module "mongodb_vpc_peer"    {
    source = "./../../infra_layer_modules/mongoDB"


    aws_account_number = var.account_number
    aws_region = var.region
    eks_cluster_name = local.k8s_cluster_name
    vpc_id = module.network.vpc.id
    vpc_cidr_block = var.cidr_block
    mongodb_cidr_block = var.mongodb_project_info.mongodb_cidr_block
    mongodb_credentials = {
        public_key = var.mongodb_project_info.public_key
        private_key = var.mongodb_project_info.private_key
    }
    eks_worker_role_arn = module.iam.eks_worker_role_arn
    atlasprojectid = var.mongodb_project_info.atlasprojectid
    mongodb_cluster_base_url = var.mongodb_project_info.mongodb_cluster_base_url

}

# sets up private endpoints between various AWS services
# to keep network traffic isolated from the public internet.
module "endpoints"  {
    source = "./../../infra_layer_modules/endpoints"
    depends_on = [
        module.mongodb_vpc_peer,
        module.network
    ]

    region = var.region

    vpc_id = module.network.vpc.id
    eks_cluster_name = local.k8s_cluster_name
    subnet_map = module.network.subnet_map
    endpoint_subnet_id_list = [module.network.subnet_map.app.A.id, module.network.subnet_map.app.B.id]  # add VPC endpoints in AZ A and AZ B
    security_group_map = module.security.security_group_map
    private_route_table_id = module.network.private_route_table.id
    mongodbatlas_peering_connection_id = module.mongodb_vpc_peer.mongodbatlas_peering_connection_id
    mongodb_cidr_block = var.mongodb_project_info.mongodb_cidr_block

}

# Attaches a NAT gateway to the private subnets, so they have
# access to the public internet
module "natgateway" {
    source = "./../../infra_layer_modules/natgateway"
    
        depends_on = [
        module.network
    ]

    region = var.region
    eks_cluster_name = local.k8s_cluster_name
    vpc_id = module.network.vpc.id
    web_subnet_map = module.network.subnet_map.web
    private_route_table_id = module.network.private_route_table.id
}



module "eks_cluster"    {
    source = "./../../infra_layer_modules/eks_cluster"

    depends_on = [ module.network, module.security, module.iam,  module.endpoints]
    aws_cli_profile = var.aws_cli_profile
    region = var.region

    eks_cluster_name = local.k8s_cluster_name
    eks_version = local.eks_version

    subnet_map = module.network.subnet_map
    security_group_map = module.security.security_group_map

    example_eks_cluster_role_arn = module.iam.example_eks_cluster_role_arn
    eks_worker_instance_profile_name = module.iam.eks_worker_instance_profile_name
    eks_worker_role_arn = module.iam.eks_worker_role_arn
    node_instance_type = local.node_instance_type
    default_tags = var.default_tags

    node_scaling_config = local.node_scaling_config

    cloudwatch_log_retention = var.cloudwatch_log_retention
}

# Web Application Firewall rules - This is attached to te ALB, so must be created before the ALB LoadBalancer Controller
module "waf" {
    depends_on = [module.eks_cluster]

    source = "./../../infra_layer_modules/waf"

    eks_oicd_connect_info = module.eks_cluster.eks_oicd_connect_info
}

module "acm_certificate" {
    depends_on = [module.eks_cluster]

    source = "./../../infra_layer_modules/acm"

    eks_oicd_connect_info = module.eks_cluster.eks_oicd_connect_info

    primary_domain = var.primary_domain
    primary_domain_host_zone_id = var.primary_domain_host_zone_id

    api_subdomain = "${var.client}.${var.client_subdomain}"

}

#updates the ~/.kube
# always_run = timestamp()
resource "null_resource" "update_kube_config" {

  depends_on = [module.eks_cluster] 

    triggers = {

        context_name = local.k8s_cluster_name
        aws_cli_profile = var.aws_cli_profile
        region = var.region
    }

    provisioner "local-exec" {
        command = join(" && ", [
        "echo Waiting for EKS Cluster to spawn.....",
        "sleep 120",
        "aws eks update-kubeconfig --name ${self.triggers.context_name} --alias ${self.triggers.context_name}  --profile ${self.triggers.aws_cli_profile} --region ${var.region}",
        # "echo $(kubectl get namespace) >> kubctl_out.txt"
        ])
        interpreter = ["/bin/bash", "-c"]
    }

}
