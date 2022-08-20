#                   This version of the code is incomplete &untested and specially released 
#                   for non-commecial public consumption. 

#                   For a production ready version,
#                   please contact the author at info@canditude.com
#                   Additional middleware is also required in application code to interact
#                   with the authorizaion servers 
resource "aws_iam_role" "eks_worker_role" {
  name = "${var.eks_cluster_name}-eks-worker-role"

  assume_role_policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
POLICY
}

resource "aws_iam_role_policy_attachment" "eks-worker-AmazonEKSWorkerNodePolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
  role       = aws_iam_role.eks_worker_role.name
}

resource "aws_iam_role_policy_attachment" "eks-worker-AmazonEKS_CNI_Policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
  role       = aws_iam_role.eks_worker_role.name
}

resource "aws_iam_role_policy_attachment" "eks-worker-AmazonEC2ContainerRegistryReadOnly" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
  role       = aws_iam_role.eks_worker_role.name
}

resource "aws_iam_role_policy_attachment" "eks-worker-CloudWatchAgentServerPolicy" {
  policy_arn = "arn:aws:iam::aws:policy/CloudWatchAgentServerPolicy"
  role       = aws_iam_role.eks_worker_role.name
}

resource "aws_iam_role_policy_attachment" "eks-worker-AmazonRoute53FullAccess" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonRoute53FullAccess"
  role       = aws_iam_role.eks_worker_role.name
}

resource "aws_iam_instance_profile" "eks_worker_instance_profile" {
  name = "${var.eks_cluster_name}-eks_worker_instance_profile"
  role = aws_iam_role.eks_worker_role.name
}


resource "aws_iam_role_policy_attachment" "eks-worker-alb-ingress-controller-role-policy" {
  policy_arn = aws_iam_policy.eks_worker_alb_ingress_controller_role_policy.arn
  role       = aws_iam_role.eks_worker_role.name
}


//TODO - DELETE IF NOT REQUIRED
resource "aws_iam_policy" "eks_worker_alb_ingress_controller_role_policy" {
    name = "${var.eks_cluster_name}-eks-worker-alb-ingress-controller-role-policy"
    description = "This policy gives the example EKS cluster ability to create and destroy ALB ingres resources as well as add DNS records in route 53"
    policy =  file("${local.iam_policy_path}/example_alb_ingress_controller_role_policy.json")
}


resource "aws_iam_role_policy_attachment" "eks-worker-cluster-autoscaler-role-policy" {
  policy_arn = aws_iam_policy.eks_worker_example_cluster_autoscaler_role_policy.arn
  role       = aws_iam_role.eks_worker_role.name
}

resource "aws_iam_policy" "eks_worker_example_cluster_autoscaler_role_policy" {
    name = "${var.eks_cluster_name}-eks-worker-cluster-autoscaler-role-policy"
    description = "This policy gives the cluster-autoscaler pod ability to autoscale the number of nodes in the clusters"
    policy =  templatefile("${local.iam_policy_path}/example_cluster_autoscaling_policy.json", {eks_cluster_name = var.eks_cluster_name})
}