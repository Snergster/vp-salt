{% set crypt = salt['pillar.get']('restrictedusers:consul:crypt', salt['grains.get']('consul_crypt', '$6rUu5wzdNP0Y')) %}
{% set bootstrap = salt['grains.get']('nomad_bootstrap', False ) %}
{% set server = salt['grains.get']('nomad_server', False ) %}
{% set agent = salt['grains.get']('nomad_agent', True ) %}
{% set public_ip = salt['network.interface_ip'](salt['grains.get']('public_port', 'bond0' )) %}


{% for nomaddir in ['/etc/nomad.d/bootstrap','/etc/nomad.d/server','/etc/nomad.d/client','/var/nomad','/etc/nomad.d/ssl/CA'] %}
{{nomaddir}}:
  file.directory:
    - makedirs: True

{% endfor %}


/etc/nomad.d/nomad.hcl:
  file.managed:
  {% if bootstrap %}
    - source: "salt://hashi/nomad/files/bootstrap.hcl"
  {% elif server %}
    - source: "salt://hashi/nomad/files/server.hcl"
  {% else %}
    - source: "salt://hashi/nomad/files/agent.hcl"
  {% endif %}
    - template: jinja
    - require:
      - file: /usr/local/bin/nomad


double check service file in place:
  file.managed:
    - name: /etc/systemd/system/nomad.service
    - source: "salt://hashi/nomad/files/nomad.service"
    - template: jinja


nomad hostname first:
  file.prepend:
    - name: /etc/hosts
    - text: {{public_ip }} {{ salt['grains.get']('id')}} {{ salt['grains.get']('id') }}

nomad reload:
  module.run:
    - name: service.systemctl_reload

nomad enabled:
  service.enabled:
    - name: nomad
    - order: last
    - enable: True
    - restart: True

nomad:
  service.running:
    - order: last
    - enable: True
    - restart: True
    - watch:
      - file: /etc/nomad.d/nomad.hcl
      - file: /etc/systemd/system/nomad.service
      
nomad service restart:
  cmd.run:
    - name: service nomad start

nomad service enabled:
  cmd.run:
    - name: systemctl enable nomad
    - require:
      - file: /etc/systemd/system/nomad.service
