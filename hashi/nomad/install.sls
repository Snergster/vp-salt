
{% set crypt = salt['pillar.get']('restrictedusers:consul:crypt', salt['grains.get']('consul_crypt', '$6rUu5wzdNP0Y')) %}

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

#nomad:
#  service:
#    - running
#    - order: last
#    - enable: True
#    - restart: True
