job "regpop" {
  datacenters = ["yul1"]

  type = "batch"
  periodic {
    cron             = "15 0 * * 1,3,5 *"
    prohibit_overlap = true
  }
  constraint {
    attribute = "${node.class}"
    value     = "master"
  }

  group "packbuild" {
    task "packer" {
      driver = "exec"
      config {
        command = "/usr/local/bin/packer build /root/regpop/regpop.json"
      }
    }
  }
}
