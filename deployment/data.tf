data "aws_eks_cluster" "main" {
  name = "eks-${local.environment}"
}

data "aws_eks_cluster_auth" "main" {
  name = "eks-${local.environment}"
}

data "aws_acm_certificate" "main" {
  domain   = "*.${local.root_domain}"
  statuses = ["ISSUED"]
}

data "aws_route53_zone" "main" {
  name         = local.root_domain
  private_zone = false
}

data "aws_elb_hosted_zone_id" "main" {}
