server {
  enabled          = true
  bootstrap_expect = 1
  encrypt = "{{salt['pillar.get']('consul:encrypt', 'foo')}}"
}
data_dir    = "/var/nomad"
datacenter = "{{salt['grains.get']('consul_datacenter', 'ewr')}}"
region = "{{salt['grains.get']('consul_region', 'global')}}"
bind_addr = "0.0.0.0"
tls {
  http = true
  rpc = true
  ca_file = "/etc/nomad.d/ssl/ca.cert"
  cert_file = "/etc/nomad.d/ssl/nomad.cert"
  key_file = "/etc/nomad.d/ssl/nomad.key"

}

consul {
  ca_file = "/etc/consul.d/ssl/ca.pem"
  cert_file = "/etc/consul.d/ssl/consul.pem"
  key_file = "/etc/consul.d/ssl/consul-key.pem"
  address = "127.0.0.1:8500"
}
