job "fabio" {
  datacenters = ["yul1"]
  type        = "system"
  priority    = 50

  update {
    stagger      = "5s"
    max_parallel = 1
  }

  group "fabio" {
    task "fabio" {
      driver = "raw_exec"

      config {
        command = "fabio-1.5.2-go1.8.3-linux_amd64"
        args = [ "-ui.access", "ro", "-proxy.addr", ":80"]
        }
       artifact {
         source = "https://github.com/fabiolb/fabio/releases/download/v1.5.2/fabio-1.5.2-go1.8.3-linux_amd64"
         options {
           checksum = "sha256:62c192a306f754b8279bf21808f725a6bae6b9de2caa59af06b62542f5e718b2"
                 }
                }
      resources {
        cpu    = 500
        memory = 74
        network {
          mbits = 1
          port "http" {
            static = 80
          }
          port "ui" {
            static = 9998
          }
        }
      }
    }
  }
}
