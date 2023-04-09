module unifi {
  source = "./modules/unifi"

  username = var.unifi.username
  password = var.unifi.password
  api_url = var.unifi.api_url
  insecure = var.unifi.insecure

  wifi_credentials = module.onepassword.wifi_credentials
}

module "onepassword" {
  source = "./modules/onepassword"

  api_url = var.onepassword.api_url
  token = var.onepassword.token
}

locals {
  helmcharts = {
    adguard-home = {
      values = {
        # needed when first installed
        # TODO: config via chart so setup isn't required
        # "probes" = {
        #   "liveness" = {
        #     "enabled" = false
        #   }
        #   "readiness" = {
        #     "enabled" = false
        #   }
        #   "startup" = {
        #     "enabled" = false
        #   }
        # }
        "dnsPolicy": "ClusterFirstWithHostNet",
        "dnsConfig": {
          "nameservers": [
            "1.1.1.1",
            "1.0.0.1"
          ]
        },
        "image": {
          "pullPolicy": "IfNotPresent",
          "repository": "adguard/adguardhome",
          "tag": "latest"
        },
        "ingress": {
          "main": {
            "enabled": true,
            "hosts": [
              {
                "host": "adguard.hand.technology",
                "paths": [
                  {
                    "path": "/",
                    "pathType": "Prefix",
                    "service": {
                      "port": 80
                    }
                  }
                ]
              }
            ],
            "tls": [
              {
                "hosts": [
                  "adguard.hand.technology"
                ]
              }
            ]
          },
          # needed when first installed
          # TODO: config via chart so setup isn't required
          "admin": {
            "enabled": false,
            "hosts": [
              {
                "host": "adguard.admin.hand.technology",
                "paths": [
                  {
                    "path": "/",
                    "pathType": "Prefix",
                    "service": {
                      "name": "adguard-home-admin"
                      "port": 3000
                    }
                  }
                ]
              }
            ]
            "tls": [
              {
                "hosts": [
                  "adguard.admin.hand.technology"
                ]
              }
            ]
          },
        },
        "persistence": {
          "config": {
            "accessMode": "ReadWriteOnce",
            "enabled": true,
            "mountPath": "/opt/adguardhome/conf",
            "size": "10Mi",
            "type": "pvc"
          },
          "work": {
            "accessMode": "ReadWriteOnce",
            "enabled": true,
            "mountPath": "/opt/adguardhome/work",
            "size": "1Gi",
            "type": "pvc"
          }
        },
        "service": {
          "main": {
            "enabled": true,
            "ports": {
              "http": {
                "enabled": true,
                "port": 80
              },
              "https": {
                "enabled": true,
                "port": 443
              },
            },
          },
          "dns-loadbalancer": {
            "enabled": true,
            "loadBalancerIP": "10.18.8.53",
            "externalTrafficPolicy": "Local",
            "ports": {
              "dns-tcp": {
                "enabled": true,
                "port": 53,
                "protocol": "TCP"
              },
              "dns-udp": {
                "enabled": true,
                "port": 53,
                "protocol": "UDP"
              },
            },
            "type": "LoadBalancer"
          },
          # needed when first installed
          # TODO: config via chart so setup isn't required
          "admin": {
            "enabled": false,
            "ports": {
              "admin": {
                "enabled": true,
                "port": 3000,
                "protocol": "TCP",
              }
            }
          }
        },
        "strategy": {
          "type": "Recreate"
        }
      }
    }
    mqtt = {
      values = {
        "configMaps": {
          "config": {
            "data": {
              "mosquitto.conf": "listener 1883\npersistence false\nlog_dest stdout\nallow_anonymous true\n"
            },
            "enabled": true
          }
        },
        "image": {
          "pullPolicy": "Always",
          "repository": "eclipse-mosquitto",
          "tag": "2.0"
        },
        "persistence": {
          "mqtt-config": {
            "enabled": true,
            "mountPath": "/mosquitto/config",
            "name": "mqtt-config",
            "type": "configMap"
          }
        },
        "probes": {
          "liveness": {
            "enabled": false
          },
          "readiness": {
            "enabled": false
          },
          "startup": {
            "enabled": false
          }
        },
        "service": {
          "main": {
            "enabled": true,
            "ports": {
              "http": {
                "enabled": true,
                "port": 9001
              },
              "listen": {
                "enabled": true,
                "port": 1883
              }
            },
            "type": "LoadBalancer"
          }
        },
        "strategy": {
          "type": "Recreate"
        }
      }
    }
    home-assistant = {
      values = {
        "image": {
          "pullPolicy": "Always",
          "repository": "ghcr.io/home-assistant/home-assistant",
          "tag": "stable"
        },
        "ingress": {
          "main": {
            "enabled": true,
            "hosts": [
              {
                "host": "hass.hand.technology",
                "paths": [
                  {
                    "path": "/",
                    "pathType": "Prefix",
                    "service": {
                      "port": 80
                    }
                  }
                ]
              }
            ],
            "tls": [
              {
                "hosts": [
                  "hass.hand.technology"
                ]
              }
            ]
          }
        },
        "persistence": {
          "config": {
            "accessMode": "ReadWriteOnce",
            "enabled": true,
            "mountPath": "/config",
            "size": "500Mi",
            "type": "pvc"
          }
        },
        "service": {
          "main": {
            "enabled": true,
            "ports": {
              "http": {
                "enabled": true,
                "port": 80,
                "targetPort": 8123
              }
            },
            "type": "ClusterIP"
          }
        },
        "strategy": {
          "type": "Recreate"
        }
      }
    }
    grocy = {
      values = {
        "env": {
          "PGID": 1000,
          "PUID": 1000,
          "TZ": "UTC"
        },
        "image": {
          "pullPolicy": "Always",
          "repository": "lscr.io/linuxserver/grocy",
          "tag": "latest"
        },
        "ingress": {
          "main": {
            "enabled": true,
            "hosts": [
              {
                "host": "grocy.hand.technology",
                "paths": [
                  {
                    "path": "/",
                    "pathType": "Prefix",
                    "service": {
                      "port": 80
                    }
                  }
                ]
              }
            ],
            "tls": [
              {
                "hosts": [
                  "grocy.hand.technology"
                ]
              }
            ]
          }
        },
        "persistence": {
          "config": {
            "accessMode": "ReadWriteOnce",
            "enabled": true,
            "mountPath": "/config",
            "size": "50Mi",
            "type": "pvc"
          }
        },
        "service": {
          "main": {
            "enabled": true,
            "ports": {
              "http": {
                "enabled": true,
                "port": 80
              }
            },
            "type": "ClusterIP"
          }
        },
        "strategy": {
          "type": "Recreate"
        }
      }
    }
    cert-manager = {
      chart = {
        repo = "https://charts.jetstack.io"
        name = "cert-manager"
      }
      values = {
        installCRDs = true
      }
    }
  }
}

resource "kubernetes_namespace" "application_charts" {
  metadata {
    name = "application-charts"
  }
}

module "helmcharts" {
  source = "./modules/helmcharts"
  for_each = local.helmcharts
  name = each.key
  chart = {
    name = lookup(lookup(each.value, "chart", {}), "name", "app-template")
    # defaults: https://github.com/bjw-s/helm-charts/blob/main/charts/
    repo = lookup(lookup(each.value, "chart", {}), "repo", "https://bjw-s.github.io/helm-charts")
  }
  namespace = {
    management = kubernetes_namespace.application_charts.id
    target = lookup(each.value, "namespace", each.key)
  }
  values = lookup(each.value, "values")
}
