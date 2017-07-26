

/var/cache/salt/consul.zip:
  file.managed:
    - source: https://releases.hashicorp.com/consul/0.9.0/consul_0.9.0_linux_amd64.zip
    - source_hash: https://releases.hashicorp.com/consul/0.9.0/consul_0.9.0_SHA256SUMS?_ga=2.7868850.1016590206.1501093818-1661805443.1495570571
  service.dead:
    - names:
      - consul
  module.run:
    - name: archive.unzip
    - zip_file: /var/cache/salt/consul.zip
    - dest: /usr/local/bin

/var/cache/salt/consul-template.zip:
  file.managed:
    - source: https://releases.hashicorp.com/consul-template/0.19.0/consul-template_0.19.0_linux_amd64.zip
    - source_hash: https://releases.hashicorp.com/consul-template/0.19.0/consul-template_0.19.0_SHA256SUMS
  module.run:
    - name: archive.unzip
    - zip_file: /var/cache/salt/consul-template.zip
    - dest: /usr/local/bin


/usr/local/bin/consul:
  file.managed:
    - mode: 0755
    - onchanges:
      - module: /var/cache/salt/consul.zip


/etc/systemd/system/consul.service:
  file.managed:
    - source: "salt://hashi/consul/files/consul.service"
    - template: jinja

consul reload:
  module.run:
    - name: service.systemctl_reload


consul:
  service.running:
    - order: last
    - enable: True
    - restart: True
    - require:
      - module: consul reload
