terraform {
  required_providers {
        mongodbatlas = {
            source  = "mongodb/mongodbatlas"
            version = "~> 0.9.0"
        }
    }
}


# Configure the MongoDB Atlas Provider
provider "mongodbatlas" {
    public_key = var.mongodb_credentials.public_key
    private_key  = var.mongodb_credentials.private_key
}


