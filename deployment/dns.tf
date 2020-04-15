resource "kubernetes_service" "main" {
  metadata {
    namespace = var.prefix
    name      = "${var.prefix}-service"
  }
  spec {
    selector = {
      app     = var.prefix
      release = local.environment
    }
    port {
      name        = "https"
      protocol    = "TCP"
      port        = "443"
      target_port = random_integer.port.result
    }
  }
}

resource "kubernetes_ingress" "main" {
  metadata {
    namespace = var.prefix
    name      = "${var.prefix}-ingress"

    labels = {
      app     = var.prefix
      release = local.environment
    }
  }

  spec {
    rule {
      host = "${var.prefix}.${local.root_domain}"

      http {
        path {
          path = "/"

          backend {
            service_name = "${var.prefix}-service"
            service_port = "443"
          }
        }
      }
    }
  }
}

resource "aws_route53_record" "main" {
  zone_id = data.aws_route53_zone.main.zone_id
  name    = "${var.prefix}.${local.root_domain}"
  type    = "A"

  alias {
    name                   = kubernetes_ingress.main.load_balancer_ingress[0].hostname
    zone_id                = data.aws_elb_hosted_zone_id.main.id
    evaluate_target_health = false
  }
}
