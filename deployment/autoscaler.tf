# resource "kubernetes_horizontal_pod_autoscaler" "main" {
#   metadata {
#     namespace = var.prefix
#     name      = "${var.prefix}-scaler"
#   }
#
#   spec {
#     max_replicas                      = var.max_replicas
#     min_replicas                      = var.min_replicas
#     target_cpu_utilization_percentage = 80
#
#     scale_target_ref {
#       api_version = "apps/v1"
#       kind        = "Deployment"
#       name        = "${var.prefix}-deployment"
#     }
#   }
# }
