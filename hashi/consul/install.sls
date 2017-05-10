
{% set crypt = salt['pillar.get']('restrictedusers:consul:crypt', salt['grains.get']('consul_crypt', '$6rUu5wzdNP0Y')) %}
{% set bootstrap = salt['grains.get']('consul_bootstrap', False ) %}
{% set server = salt['grains.get']('consul_server', False ) %}
{% set agent = salt['grains.get']('consul_agent', False ) %}

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


/usr/local/bin/consul:
  file.managed:
    - mode: 0755
    - onchanges:
      - module: /var/cache/salt/consul.zip

consul group:
  group.present:
    - name: consul

consul user:
  user.present:
    - name: consul
    - require:
      - group: consul group
    - fullname: Consul user
    - shell: /bin/bash
    - home: /home/consul
    - groups:
      - consul
    - password: {{ crypt }}

{% for consuldir in ['/etc/consul.d/bootstrap','/etc/consul.d/server','/etc/consul.d/client','/var/consul','/etc/consul.d/ssl/CA'] %}
{{consuldir}}:
  file.directory:
    - require:
      - user: consul user
    - user: consul
    - group: consul
    - makedirs: True

{% endfor %}

/etc/consul.d/ssl/ca.cert:
  file.managed:
    - contents_pillar: consul:cacert
    - user: consul
    - group: consul

/etc/consul.d/ssl/consul.cert:
  file.managed:
    - contents_pillar: consul:sslcert
    - user: consul
    - group: consul

/etc/systemd/system/consul.service:
  file.managed:
    - source: "salt://hashi/consul/files/consul.service"
    - template: jinja

/etc/dnsmasq.d/10-consul:
  file.managed:
    - source: "salt://hashi/consul/files/10-consul"
    - template: jinja
    - require:
      - pkg: dnsmasq

/etc/dnsmasq.d/20-text:
  file.managed:
    - contents_pillar: consul:letstext
    - require:
      - pkg: dnsmasq


/etc/consul.d/consul.json:
  file.managed:
  {% if bootstrap %}
    - source: "salt://hashi/consul/files/consul-bootstrap-config.json"
  {% elif server %}
    - source: "salt://hashi/consul/files/consul-server-config.json"
  {% elif agent %}
    - source: "salt://hashi/consul/files/consul-agent-config.json"
  {% endif %}
    - template: jinja
    - require:
      - file: /usr/local/bin/consul


/etc/consul.d/ssl/consul.key:
  file.managed:
    - contents_pillar: consul:sslkey
    - user: consul
    - group: consul

dnsmasq package install:
  pkg.installed:
    - name: dnsmasq
    - refresh: false

dnsmasq replace:
  file.prepend:
    - name: /etc/dnsmasq.conf
    - text: resolv-file=/etc/resolv.conf.dnsmasq

dnsmasq resolv version:
  file.copy:
    - name: /etc/resolv.conf.dnsmasq
    - source: /etc/resolv.conf

consul into dns:
  file.prepend:
    - name: /etc/resolv.conf
    - text: nameserver 127.0.0.1
    - require:
      - pkg: dnsmasq
      - file: dnsmasq resolv version

consul:
  service:
    - running
    - order: last
    - enable: True
    - restart: True

dnsmasq:
  service:
    - running
    - order: last
    - enable: True
    - restart: True
