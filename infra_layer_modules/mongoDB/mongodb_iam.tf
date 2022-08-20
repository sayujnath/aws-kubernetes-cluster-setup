
# generates a random password for cluster to access the database
resource "random_password" "cashd_db_prod_pwd" {

    length = 20
    special = false
    upper = true
    override_special = "-"
}

# Creates database user credentials using username and password to generate connection string
resource "mongodbatlas_database_user" "db_user" {

    username           = var.eks_cluster_name
    password           = random_password.cashd_db_prod_pwd.result
    project_id         = var.atlasprojectid
    auth_database_name = "admin"

    roles {
        role_name     = "readWriteAnyDatabase"
        database_name = "admin"
    }

    labels {
        key   = "PreparedBy"
        value = "canditude"
    }

    labels {
        key   = "GeneratedBy"
        value = "terraform"
    }


    scopes {
        name   = split(".", var.mongodb_cluster_base_url)[0]
        type = "CLUSTER"
    }

}


# Creates database user credentials with IAM role access to access using eks node worker role
resource "mongodbatlas_database_user" "db_iam_eks_node_role" {

    aws_iam_type = "ROLE"
    
    username           = var.eks_worker_role_arn
    project_id         = var.atlasprojectid
    auth_database_name = "$external"

    roles {
        role_name     = "readWriteAnyDatabase"
        database_name = "admin"
    }

    labels {
        key   = "PreparedBy"
        value = "canditude"
    }

    labels {
        key   = "GeneratedBy"
        value = "terraform"
    }

    scopes {
        name   = split(".", var.mongodb_cluster_base_url)[0]
        type = "CLUSTER"
    }

}