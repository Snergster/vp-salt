server {
  enabled          = false
}
data_dir    = "/var/nomad"
datacenter = "{{salt['grains.get']('consul_datacenter', 'ewr')}}"
region = "{{salt['grains.get']('consul_region', 'global')}}"
client {
  enabled       = true
  no_host_uuid = true
  options {
    "driver.raw_exec.enable" = "0"
    "docker.cleanup.image" = "false"
    "docker.privileged.enabled" = "true"
  }
}
bind_addr = "0.0.0.0"
tls {
  http = false
  rpc = false
  ca_file = "/etc/nomad.d/ssl/ca.cert"
  cert_file = "/etc/nomad.d/ssl/nomad.cert"
  key_file = "/etc/nomad.d/ssl/nomad.key"

}

consul {
  address = "127.0.0.1:8500"
}