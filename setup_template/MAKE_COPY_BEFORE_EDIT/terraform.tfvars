######################################################################################

#   Title	=	"Example   App AWS cloud resources
#   Author	=	"Sayuj Nath, Cloud Solutions Architect
#   Comapany	=	"Canditude
#                   Prepared for  public non-commercial use
#   Description	=	"Computing resources for
#                   development and deployment using AWS
#                   public cloud resources for the example Applications
#   File Desc	=	"Constants to pass to main_setup, containing tagging
#                   information.
#

#######################################################################################


#AWS setup
account_number = "XXXXXXXXX"                         // MODIFY FOR NEW DEPLOYMENT - another account

region = "ap-southeast-1"                               // MODIFY FOR NEW DEPLOYMENT - new region
aws_cli_profile = aws-profile                          // MODIFY FOR NEW DEPLOYMENT - another account

#networking
cidr_block = MAKE_UNIQUE    # Ie "10.12.0.0/16"                              // !!!!!!!!!!!!!!!!!! MODIFY FOR NEW DEPLOYMENT - alternative unused CIDR block for VPC

deployment_name = MAKE_UNIQUE   #ie. "example-sgp"                          // !!!!!!!!!!!!!! MODIFY FOR NEW DEPLOYMENT - deployment resources will be named after this
client = MAKE_UNIQUE        # ie. "canditude-dev"                                // !!!!!!!!!!!!!! MODIFY FOR NEW DEPLOYMENT - the application instance and subdoomain will be names after this ie. client.api.sgp. exampleexample.com.au

client_subdomain = "example-subdomain"                  // MODIFY FOR NEW DEPLOYMENT - new region or subdomain <client>.<client_subdomain>. exampleexample.com.au


#DNS
primary_domain_host_zone_id = "ZXXXXXXXXXXXXXXXXXV"   // MODIFY FOR NEW DEPLOYMENT - alternative application domain
primary_domain = " example.co"                       // MODIFY FOR NEW DEPLOYMENT - alternative application domain

#container registry
ecr_image_location =  "0XXXXXXXXXXX8.dkr.ecr.ap-southeast-1.amazonaws.com/ example/example/api/main:branch_master" // MODIFY FOR NEW APPLICATION - alternative application image location

health_check_path = "/"         // MODIFY FOR NEW APPLICATION - alternative application healthcheck

// MODIFY FOR NEW DEPLOYMENT - alternative database and credentials
mongodb_project_info = {
    public_key = "cXXXXXXXd"                                     // !!!!!!! MODIFY FOR NEW DEPLOYMENT - It is best practice to create a new key for each MongoDB deployment.
    private_key = "9XXXXXXXXXXXXXXXXXXXXXXXb7"        // !!!!!!! MODIFY FOR NEW DEPLOYMENT - It is best practice to create a new key for each MongoDB deployment.
    atlas_region = "AP_SOUTHEAST_1"
    mongodb_cidr_block = "192.168.248.0/21"
    atlasprojectid = "XXXXXXXXXXXXXXXXXXX"
    mongodb_cluster_base_url = example.XXXXXXXXX.mongodb.net/CORRECT_DATABASE   // !!!!!!!! - Ensure deployment is pointing to the correct database/collection
}

# Tags are used to designate ownership of resources
default_tags = {
    Project = MAKEUNIQUE                            # "example-v1" or "example-v2" // !!!!!!!!!!! MODIFY FOR NEW DEPLOYMENT -  application domain or project
    EndUser = MAKEUNIQUE                            //  ie. internal !!!!!!!!!!! MODIFY FOR NEW DEPLOYMENT -  end user for application
    PreparedBy = MAKEUNIQUE                         # ie. "canditude"   // !!!!!  MODIFY FOR NEW DEPLOYMENT -  engineer responsible for deployment
    GeneratedBy = "terraform"
}

#in days
cloudwatch_log_retention = 14

pod_env_variables = {                           // MODIFY FOR NEW APPLICATION - alternative environmental variables for application 

    EXAMPLE_ENVIRONMEMTAL_VARIABLE	=	"some value"

}