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
    "driver.whitelist" = "docker"
  }
}
bind_addr = "0.0.0.0"
tls {
  http = false
  rpc = false
  ca_file = "/etc/nomad.d/ssl/ca.pem"
  cert_file = "/etc/nomad.d/ssl/nomad.pem"
  key_file = "/etc/nomad.d/ssl/nomad-key.pem"

}

consul {
  address = "127.0.0.1:8500"
}