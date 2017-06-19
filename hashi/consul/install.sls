

/var/cache/salt/consul.zip:
  file.managed:
    - source: https://releases.hashicorp.com/consul/0.8.4/consul_0.8.4_linux_amd64.zip
    - source_hash: https://releases.hashicorp.com/consul/0.8.4/consul_0.8.4_SHA256SUMS?_ga=2.57157225.2124633943.1497889162-1661805443.1495570571
  service.dead:
    - names:
      - consul
  module.run:
    - name: archive.unzip
    - zip_file: /var/cache/salt/consul.zip
    - dest: /usr/local/bin

/var/cache/salt/consul-template.zip:
  file.managed:
    - source: https://releases.hashicorp.com/consul-template/0.18.5/consul-template_0.18.5_linux_amd64.zip
    - source_hash: https://releases.hashicorp.com/consul-template/0.18.5/consul-template_0.18.5_SHA256SUMS
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
