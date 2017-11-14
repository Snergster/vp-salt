
{% set crypt = salt['pillar.get']('restrictedusers:consul:crypt', salt['grains.get']('consul_crypt', '$6rUu5wzdNP0Y')) %}
{% set bootstrap = salt['grains.get']('consul_bootstrap', False ) %}
{% set server = salt['grains.get']('consul_server', False ) %}
{% set agent = salt['grains.get']('consul_agent', False ) %}


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

