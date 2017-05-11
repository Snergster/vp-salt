

/var/cache/salt/consul.zip:
  file.managed:
    - source: https://releases.hashicorp.com/consul/0.8.2/consul_0.8.2_linux_amd64.zip
    - source_hash: 6409336d15baea0b9f60abfcf7c28f7db264ba83499aa8e7f608fb0e273514d9
  service.dead:
    - names:
      - consul
  module.run:
    - name: archive.unzip
    - zip_file: /var/cache/salt/consul.zip
    - dest: /usr/local/bin

/var/cache/salt/consul-template.zip:
  file.managed:
    - source: https://releases.hashicorp.com/consul-template/0.18.3/consul-template_0.18.3_linux_amd64.zip
    - source_hash: caf6018d7489d97d6cc2a1ac5f1cbd574c6db4cd61ed04b22b8db7b4bde64542
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



consul:
  service:
    - running
    - order: last
    - enable: True
    - restart: True

