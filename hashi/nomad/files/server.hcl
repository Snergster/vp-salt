server {
  enabled          = true
  bootstrap_expect = 1
}
data_dir    = "/var/nomad"
datacenter = "{{salt['grains.get']('consul_datacenter', 'ewr')}}"
region = "{{salt['grains.get']('consul_region', 'us')}}"
advertise {
  http = "{{  salt['network.interface_ip']('bond0') }}:4646"
  rpc = "{{  salt['network.interface_ip']('bond0') }}"
  serf = "{{  salt['network.interface_ip']('bond0') }}"
  }
client {
  enabled       = true
  servers = ["{{  salt['network.interface_ip']('bond0') }}:4647"]
  no_host_uuid = true
  options {
    "driver.raw_exec.enable" = "1"
    "docker.cleanup.image" = "false"
    "docker.privileged.enabled" = "true"
  }
}
consul {
  address = "{{  salt['network.interface_ip']('bond0') }}:8500"
}
