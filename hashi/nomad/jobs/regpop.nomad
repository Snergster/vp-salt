
job "regpop" {
  datacenters = ["yul1"]

  type = "batch"
  periodic {
    cron             = "15 7 * * 1,3,5 *"
    prohibit_overlap = true
    time_zone = "UTC"
  }
  constraint {
    attribute = "${node.class}"
    value     = "master"
  }

  group "packbuild" {
    task "packer" {
      driver = "raw_exec"
      config {
        command = "/usr/local/bin/packer"
        args = ["build", "/root/regpop/regpop.json"] 
      }
    }
  }
}