
{% set crypt = salt['pillar.get']('restrictedusers:consul:crypt', salt['grains.get']('consul_crypt', '$6rUu5wzdNP0Y')) %}

/var/cache/salt/vault.zip:
  file.managed:
    - source: https://releases.hashicorp.com/vault/0.7.0/vault_0.7.0_linux_amd64.zip
    - source_hash: c6d97220e75335f75bd6f603bb23f1f16fe8e2a9d850ba59599b1a0e4d067aaa
  service.dead:
    - names:
      - vault
  module.run:
    - name: archive.unzip
    - zip_file: /var/cache/salt/vault.zip
    - dest: /usr/local/bin


/usr/local/bin/vault:
  file.managed:
    - mode: 0755
    - onchanges:
      - module: /var/cache/salt/vault.zip

{% for vaultdir in ['/etc/vault.d/bootstrap','/etc/vault.d/server','/etc/vault.d/client','/var/vault','/etc/vault.d/ssl/CA'] %}
{{vaultdir}}:
  file.directory:
    - makedirs: True

{% endfor %}

#vault5068:
#  service:
#    - running
#    - order: last
#    - enable: True
#    - restart: True
