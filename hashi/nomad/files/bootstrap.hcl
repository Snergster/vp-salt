server {
  enabled          = true
  bootstrap_expect = 1
  encrypt = "{{salt['pillar.get']('consul:encrypt', 'foo')}}"
}
data_dir    = "/var/nomad"
datacenter = "{{salt['grains.get']('consul_datacenter', 'ewr')}}"
region = "{{salt['grains.get']('consul_region', 'us')}}"
bind_addr = "0.0.0.0"
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
