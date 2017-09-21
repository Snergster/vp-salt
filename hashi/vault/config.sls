{% set crypt = salt['pillar.get']('restrictedusers:consul:crypt', salt['grains.get']('consul_crypt', '$6rUu5wzdNP0Y')) %}


{% for vaultdir in ['/etc/vault.d/bootstrap','/etc/vault.d/server','/etc/vault.d/client','/var/vault','/etc/vault.d/ssl/CA'] %}
{{vaultdir}}:
  file.directory:
    - makedirs: True

{% endfor %}

/etc/vault.d/server.hcl:
  file.managed:
    - source: "salt://hashi/vault/files/server.hcl"
    - template: jinja
    - require:
      - file: /usr/local/bin/vault
