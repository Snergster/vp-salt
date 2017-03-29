
{% set crypt = salt['pillar.get']('restrictedusers:consul:crypt', salt['grains.get']('consul_crypt', '$6rUu5wzdNP0Y')) %}
{% set bootstrap = salt['grains.get']('consul_bootstrap', False )) %}
{% set server = salt['grains.get']('consul_server', False )) %}
{% set agent = salt['grains.get']('consul_agent', False )) %}

/var/cache/salt/consul.zip:
  file.managed:
    - source: https://releases.hashicorp.com/consul/0.7.5/consul_0.7.5_linux_amd64.zip
    - source_hash: 40ce7175535551882ecdff21fdd276cef6eaab96be8a8260e0599fadb6f1f5b8
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

/etc/consul.d/consul.conf:
  file.managed:
  {% if boostrap %}
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

dnsmasq:
  pkg.installed:
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
