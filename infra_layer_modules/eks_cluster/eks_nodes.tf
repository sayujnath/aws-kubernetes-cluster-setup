resource "aws_eks_node_group" "eks_worker_group" {

  cluster_name    = aws_eks_cluster.eks-cluster-example.name
  node_group_name = "${var.eks_cluster_name}-worker-group"
  node_role_arn   = var.eks_worker_role_arn
  subnet_ids      = [var.subnet_map.app.A.id, var.subnet_map.app.B.id]   # add EKS nodes in AZ A and AZ B in app tier
  launch_template {
    name = aws_launch_template.eks_node_launch_template.name
    version = aws_launch_template.eks_node_launch_template.latest_version
    }
  scaling_config {
    desired_size = var.node_scaling_config.desired
    max_size     = var.node_scaling_config.max
    min_size     = var.node_scaling_config.min
  }

  update_config {
    max_unavailable = 1
  }
  lifecycle {
    ignore_changes = [scaling_config[0].desired_size]
  }
}


resource "aws_launch_template" "eks_node_launch_template" {
  name = "${var.eks_cluster_name}-worker-node"


  # image_id = aws_ami_copy.eks_worker_encrypted.id

  instance_type = var.node_instance_type

  block_device_mappings {
      device_name = "/dev/sda1"

      ebs {
        volume_size = 20
      }
    }
    
  vpc_security_group_ids = [var.security_group_map.app.id]    // node workers are in the application tier

  tag_specifications {
    resource_type = "instance"

# These tags are needed to be dicovered by the autoscaler.
    tags = {
      Name  = "${var.eks_cluster_name}-worker-node"
      "k8s.io/cluster-autoscaler/${aws_eks_cluster.eks-cluster-example.name}" = "shared"
      "k8s.io/cluster-autoscaler/enabled" = true
    }
  }
  # user_data = base64encode(local.eks-worker-userdata)

}



locals {
  eks-worker-userdata = <<USERDATA
#!/bin/bash
set -o xtrace
yum install -y amazon-ssm-agent
systemctl enable amazon-ssm-agent && systemctl start amazon-ssm-agent
/etc/eks/bootstrap.sh --apiserver-endpoint '${aws_eks_cluster.eks-cluster-example.endpoint}' --b64-cluster-ca '${aws_eks_cluster.eks-cluster-example.certificate_authority.0.data}' '${aws_eks_cluster.eks-cluster-example.name}'
USERDATA
}





# data "aws_ami" "amazon_linux_2" {
#   most_recent = true
#   owners = ["amazon"] # Canonical


#   filter {
#     name   = "name"
#     values = ["amazon-eks-*"]
#   }
  
# }

# data "aws_ami" "eks_worker_ami" {
#   most_recent = true
#   owners = ["amazon"] # Canonical

#   filter {
#     name   = "name"
#     values = ["amazon-eks-node-${var.eks_version}*"]

#   }
# }

# # create an encrypted copy of the AMI
# resource "aws_ami_copy" "eks_worker_encrypted" {
#   name = "${var.eks_cluster_name}-worker-encrypted"
#   description = "Encrypted version of worker AMI"
#   source_ami_id = data.aws_ami.eks_worker_ami.id
#   source_ami_region = var.region
#   encrypted = true

#   tags = {
#     Name = "${var.eks_cluster_name}-worker-encrypted"
#   }
# }