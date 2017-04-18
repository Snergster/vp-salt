backend "consul" {
  address = "127.0.0.1:8500"
  path = "vault/"
}

listener "tcp" {
 address = "{{  salt['network.interface_ip']('bond0') }}:8200"
 cluster_address = "{{  salt['network.interface_ip']('bond0') }}:8201"
 tls_cert_file = "/etc/consul.d/ssl/consul.cert"
 tls_key_file = "/etc/consul.d/ssl/consul.key"
}
cluster_name = "ejkern"
