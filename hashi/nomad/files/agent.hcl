server {
  enabled          = false
}
data_dir    = "/var/nomad"
datacenter = "{{salt['grains.get']('consul_datacenter', 'ewr')}}"
region = "{{salt['grains.get']('consul_region', 'us')}}"
client {
  enabled       = true
  servers = ["{{salt['grains.get']('consul_server', '147.75.105.153')}}:4647"]
  no_host_uuid = true
  options {
    "driver.raw_exec.enable" = "1"
    "docker.cleanup.image" = "false"
    "docker.privileged.enabled" = "true"
  }
}

tls {
  http = true
  rpc = true
  ca_file = "/etc/letsencrypt/live/{{salt['grains.get']('consul_domain', 'consul')}}/fullchain.pem"
  cert_file = "/etc/letsencrypt/live/{{salt['grains.get']('consul_domain', 'consul')}}/cert.pem"
  key_file = "/etc/letsencrypt/live/{{salt['grains.get']('consul_domain', 'consul')}}/privkey.pem"

}

consul {
  address = "127.0.0.1:8500"
}