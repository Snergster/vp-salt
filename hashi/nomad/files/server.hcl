server {
  enabled          = true
  encrypt = "{{salt['pillar.get']('consul:encrypt', 'foo')}}"
}
data_dir    = "/var/nomad"
datacenter = "{{salt['grains.get']('consul_datacenter', 'ewr1')}}"
region = "{{salt['grains.get']('consul_region', 'global')}}"
bind_addr = "0.0.0.0"
tls {
  http = true
  rpc = true
  ca_file = "/etc/letsencrypt/live/{{salt['grains.get']('consul_domain', 'consul')}}/fullchain.pem"
  cert_file = "/etc/letsencrypt/live/{{salt['grains.get']('consul_domain', 'consul')}}/cert.pem"
  key_file = "/etc/letsencrypt/live/{{salt['grains.get']('consul_domain', 'consul')}}/privkey.pem"

}


consul {
  ca_file = "/etc/consul.d/ssl/ca.pem"
  cert_file = "/etc/consul.d/ssl/consul.pem"
  key_file = "/etc/consul.d/ssl/consul-key.pem"
  address = "127.0.0.1:8500"
}
