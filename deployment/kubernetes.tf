resource "kubernetes_namespace" "main" {
  metadata {
    name = var.prefix
  }
}

resource "random_integer" "port" {
  min     = 8000
  max     = 9999
}

resource "kubernetes_deployment" "main" {
  metadata {
    namespace = var.prefix
    name      = "${var.prefix}-deployment"

    labels = {
      app     = var.prefix
      release = local.environment
    }
  }

  spec {
    replicas               = var.min_replicas
    revision_history_limit = 0

    selector {
      match_labels = {
        app = var.prefix
      }
    }

    template {
      metadata {
        labels = {
          app     = var.prefix
          release = local.environment
        }
      }

      spec {
        node_selector = {
          name = "primary"
        }

        container {
          image             = "${aws_ecr_repository.main.repository_url}:latest"
          name              = var.prefix
          image_pull_policy = "Always"

          port {
            name           = "http"
            container_port = random_integer.port.result
            protocol       = "TCP"
          }

          env {
            name  = "PORT"
            value = random_integer.port.result
          }

          resources {
            limits {
              cpu    = "250m"
              memory = "128Mi"
            }
            requests {
              cpu    = "125m"
              memory = "64Mi"
            }
          }

          liveness_probe {
            http_get {
              path = "/health-check"
              port = random_integer.port.result
            }

            initial_delay_seconds = 10
            period_seconds        = 30
          }
        }
      }
    }
  }

  lifecycle {
    ignore_changes = [
      # This gets changed with the autoscaler all the time
      spec[0].replicas,
    ]
  }
}
