job "jenkins-master" {
  region = "{{salt['grains.get']('consul_region', 'us')}}"
  datacenters = ["{{salt['grains.get']('consul_datacenter', 'ewr')}}"]
  type        = "service"
  priority    = 50

  update {
    stagger      = "10s"
    max_parallel = 1
  }

  group "jenkins-master" {
    count = 1

    restart {
      attempts = 10
      interval = "5m"
      delay    = "25s"
      mode     = "delay"
    }

    task "jenkins-master" {
      driver = "docker"

      config {
        image = "registry.service.consul:5000/jenkins/master"
        volumes = [ "/var/jenkins:/var/jenkins_home"]
        port_map {
          http = 8080
          jnlp = 50000
        }
      }

      service {
        name = "jenkins-master"
        tags = ["global", "jenkins", "master"]
        port = "http"

        check {
          name     = "alive"
          type     = "tcp"
          interval = "10s"
          timeout  = "2s"
        }
      }

      resources {
        cpu    = 2000
        memory = 2000

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
