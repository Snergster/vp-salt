server {
  enabled          = true
  bootstrap_expect = 1
  encrypt = "{{salt['pillar.get']('consul:encrypt', 'foo')}}"
}
data_dir    = "/var/nomad"
datacenter = "{{salt['grains.get']('consul_datacenter', 'ewr')}}"
region = "{{salt['grains.get']('consul_region', 'us')}}"
bind_address = "{{  salt.network.ip_addrs(interface='bond0',type='private')[0] }}"
tls {
  http = false
  rpc = false
  ca_file       = "/etc/consul.d/ssl/ca.cert"
  cert_file = "/etc/consul.d/ssl/consul.cert"
  key_file = "/etc/consul.d/ssl/consul.key"
}

consul {
  address = "{{  salt.network.ip_addrs(interface='bond0',type='private')[0] }}:8500"
}
