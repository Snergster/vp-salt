server {
  enabled          = true
  bootstrap_expect = 2
  encrypt = "{{salt['pillar.get']('consul:encrypt', 'foo')}}"
  retry_join = ["{{salt['grains.get']('consul_server_ip', '147.75.105.153')}}"],
}
data_dir    = "/var/nomad"
datacenter = "{{salt['grains.get']('consul_datacenter', 'ewr')}}"
region = "{{salt['grains.get']('consul_region', 'us')}}"
advertise {
  http = "{{  salt['network.interface_ip']('bond0') }}:4646"
  rpc = "{{  salt['network.interface_ip']('bond0') }}"
  serf = "{{  salt['network.interface_ip']('bond0') }}"
  }
tls {
  http = true
  rpc = true
  ca_file       = "/etc/consul.d/ssl/ca.cert"
  cert_file = "/etc/consul.d/ssl/consul.cert"
  key_file = "/etc/consul.d/ssl/consul.key"
}

consul {
  address = "{{  salt['network.interface_ip']('bond0') }}:8500"
}
