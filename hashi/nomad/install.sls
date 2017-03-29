
{% set crypt = salt['pillar.get']('restrictedusers:consul:crypt', salt['grains.get']('consul_crypt', '$6rUu5wzdNP0Y')) %}
{% set server = salt['grains.get']('nomad_server', False ) %}
{% set agent = salt['grains.get']('nomad_agent', True ) %}

/var/cache/salt/nomad.zip:
  file.managed:
    - source: https://releases.hashicorp.com/nomad/0.5.5/nomad_0.5.5_linux_amd64.zip
    - source_hash: 13ecd22bbbffab5b8261c2146af54fdf96a22c46c6618d6b5fd0f61938b95068
  service.dead:
    - names:
      - nomad
  module.run:
    - name: archive.unzip
    - zip_file: /var/cache/salt/nomad.zip
    - dest: /usr/local/bin

/etc/systemd/system/nomad.service:
  file.managed:
    - source: "salt://hashi/nomad/files/nomad.service"
    - template: jinja


/usr/local/bin/nomad:
  file.managed:
    - mode: 0755
    - onchanges:
      - module: /var/cache/salt/nomad.zip

{% for nomaddir in ['/etc/nomad.d/bootstrap','/etc/nomad.d/server','/etc/nomad.d/client','/var/nomad','/etc/nomad.d/ssl/CA'] %}
{{nomaddir}}:
  file.directory:
    - makedirs: True

{% endfor %}

/etc/nomad.d/nomad.hcl:
  file.managed:
  {% if server %}
    - source: "salt://hashi/nomad/files/server.hcl"
  {% elif agent %}
    - source: "salt://hashi/nomad/files/agent.hcl"
  {% endif %}
    - template: jinja
    - require:
      - file: /usr/local/bin/nomad

