
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

/etc/consul.d/consul.json:
  file.managed:
  {% if bootstrap %}
    - source: "salt://hashi/consul/files/consul-bootstrap-config.json"
  {% elif server %}
    - source: "salt://hashi/consul/files/consul-server-config.json"
  {% elif agent %}
    - source: "salt://hashi/consul/files/consul-agent-config.json"
  {% else %}
    - source: "salt://hashi/consul/files/consul-agent-config.json"
  {% endif %}
    - template: jinja
    - require:
      - file: /usr/local/bin/consul

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

consul service restart:
  cmd.run:
    - name: service consul start

consul service enabled:
  cmd.run:
    - name: systemctl enable consul
    - require:
      - file: /etc/systemd/system/consul.service

