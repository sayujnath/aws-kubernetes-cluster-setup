
terraform {
    required_providers {
        aws = {
            source  = "hashicorp/aws"
            version = "~> 3.0"
        }


        local = {
            source  = "hashicorp/local"
            version = "2.1.0"
        }
    }

    backend "s3" {
        bucket = " example-terraform-state-sg"     # MODIFY FOR NEW DEPLOYMENT - new region for bucket. Please create the bucket first.
        key    = MAKE_UNIQUE/terraform.tfstate  #ie. "example-deployment/terraform.tfstate"   // !!!!!!!! MODIFY FOR NEW DEPLOYMENT - new key in s3 for new deployment in existing region
        encrypt = true
        region = "ap-southeast-1"               # MODIFY FOR NEW DEPLOYMENT - new region
        profile = "prod-us-west-2"                    # MODIFY FOR NEW DEPLOYMENT - alternative AWS credentials for different account
        dynamodb_table = " example-terraform-state-sg" # MODIFY FOR NEW DEPLOYMENT - new lock for each deployment
    }

}

# Configure the AWS Provider and region
provider "aws" {
    profile = var.aws_cli_profile
    region = var.region

    default_tags {
    tags = var.default_tags
  }
}

// Housekeepig - creates resource group that collects all resources tagged by this setup.
resource "aws_resourcegroups_group" "example-dev-resource-group" {
    name = "${var.deployment_name}"

    resource_query {
        query = <<JSON
{
"ResourceTypeFilters": [
    "AWS::AllSupported"
],
"TagFilters": [
    {
    "Key": "Project",
    "Values": ["${var.default_tags.Project}"]
    },
    {
    "Key": "EndUser",
    "Values": ["${var.default_tags.EndUser}"]
    }
]
}
    JSON
}
}