storage "consul" {
  address = "127.0.0.1:8500"
  redirect_addr = "https://{{ salt['network.interface_ip']('bond0') }}:8200"
  path = "vault"
}

listener "tcp" {
 address = "{{ salt['network.interface_ip']('bond0') }}:8200"
 tls_cert_file = "/etc/letsencrypt/live/ejkern.net/fullchain.pem"
 tls_key_file = "/etc/letsencrypt/live/ejkern.net/privkey.pem"
}
cluster_name = "ejkern"
