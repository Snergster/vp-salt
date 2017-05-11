
{% set crypt = salt['pillar.get']('restrictedusers:consul:crypt', salt['grains.get']('consul_crypt', '$6rUu5wzdNP0Y')) %}
{% set bootstrap = salt['grains.get']('consul_bootstrap', False ) %}
{% set server = salt['grains.get']('consul_server', False ) %}
{% set agent = salt['grains.get']('consul_agent', False ) %}

include:
  - common.dnsmasq
  - hashi.consul.install

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

consul enabled:
  service.enabled:
    - name: consul
    - order: last
    - enable: True
    - restart: True

consul running:
  service.running:
    - name: consul
    - order: last
    - enable: True
    - restart: True
