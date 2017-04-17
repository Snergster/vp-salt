
{% set crypt = salt['pillar.get']('restrictedusers:consul:crypt', salt['grains.get']('consul_crypt', '$6rUu5wzdNP0Y')) %}
{% set server = salt['grains.get']('nomad_server', False ) %}
{% set agent = salt['grains.get']('nomad_agent', True ) %}

liblxc1:
  pkg.installed:
    - refresh: false



/var/cache/salt/nomad.zip:
  file.managed:
    - source: https://releases.hashicorp.com/nomad/0.5.6/nomad_0.5.6_linux_amd64-lxc.zip
    - source_hash: ccf090208a681066838bf85f3282737c0435e37bcb8d24e07b1a4edc91f34d97
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

