job "jenkins" {
  datacenters = ["yul1"]
  type        = "service"
  priority    = 50

  update {
    stagger      = "10s"
    max_parallel = 1
  }

  group "jenkins" {
    count = 1

    restart {
      attempts = 10
      interval = "5m"
      delay    = "25s"
      mode     = "delay"
    }

    task "jenkins" {
      driver = "docker"

      config {
        image = "registry.service.ejkern.net:5000/jenkins/master"
        volumes = [ "/var/jenkins:/var/jenkins_home"]
        port_map {
          http = 8080
          jnlp = 50000
        }
      }

      constraint {
    attribute = "${node.class}"
    value = "master"
      }

      service {
        name = "jenkins"
        tags = ["global", "jenkins", "master", "urlprefix-jenkins.service.consul/", "urlprefix-jenkins.ejkern.net/"]
        port = "http"

        check {
          name     = "alive"
          type     = "tcp"
          port     = "http"
          interval = "10s"
          timeout  = "2s"
        }
      }

      resources {
        cpu    = 10000
        memory = 8000

        network {
          mbits = 10

          port "http" {
            static = 8080
          }

          port "jnlp" {
            static = 50000
          }
        }
      }

      logs {
        max_files     = 10
        max_file_size = 15
      }

      kill_timeout = "20s"
    }
  }
}
