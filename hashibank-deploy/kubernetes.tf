# hashibank deployment
resource "kubernetes_deployment" "hashibank" {
  metadata {
    name = "hashibank"
    namespace = var.hashibank_namespace
  }

  spec {
    replicas = 1

    selector {
      match_labels = {
        app = "hashibank"
      }
    }

    template {
      metadata {
        labels = {
          app = "hashibank"
        }
      }

      spec {
        container {
          image = "jamiewri/hashibank:0.0.3"
          name  = "hashibank"

          args = [
            "-dev",
          ]

          port {
            container_port = 8080
          }

            resources {
                limits = {
                cpu    = "200m"
                memory = "256Mi"
                }

                requests = {
                cpu    = "100m"
                memory = "128Mi"
                }
            }

        }
      }
    }
  }
}


resource "time_sleep" "wait_30_seconds" {
  depends_on = [kubernetes_deployment.hashibank]

  create_duration = "30s"
  # allow for ingress controller to be ready
}


# hashibank service
resource "kubernetes_service_v1" "hashibank" {
  metadata {
    name      = "hashibank"
    namespace = var.hashibank_namespace
  }

  spec {
    selector = {
      app = "hashibank"
    }

    port {
      protocol    = "TCP"
      port        = 8080
      target_port = 8080
    }

    type = "ClusterIP"
  }
}

#hashibank ingress
resource "kubernetes_ingress_v1" "hashibank" {
  depends_on = [time_sleep.wait_30_seconds]
  metadata {
    name        = "hashibank"
    namespace = var.hashibank_namespace
    annotations = {
      "kubernetes.io/ingress.class"             = "alb"
      "alb.ingress.kubernetes.io/scheme"        = "internet-facing"
      "alb.ingress.kubernetes.io/target-type"   = "ip"
    }
  }

  spec {
    ingress_class_name = "alb"

    rule {
      http {
        path {
          path     = "/"
          path_type = "Prefix"

          backend {
            service {
              name = "hashibank"
              port {
                number = 8080
              }
            }
          }
        }
      }
    }
  }
}
