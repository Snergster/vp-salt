
{% set crypt = salt['pillar.get']('restrictedusers:consul:crypt', salt['grains.get']('consul_crypt', '$6rUu5wzdNP0Y')) %}

/var/cache/salt/vault.zip:
  file.managed:
    - source: https://releases.hashicorp.com/vault/0.7.2/vault_0.7.2_linux_amd64.zip
    - source_hash: 22575dbb8b375ece395b58650b846761dffbf5a9dc5003669cafbb8731617c39
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

/etc/vault.d/server.hcl:
  file.managed:
    - source: "salt://hashi/vault/files/server.hcl"
    - template: jinja
    - require:
      - file: /usr/local/bin/vault


/etc/systemd/system/vault.service:
  file.managed:
    - source: "salt://hashi/vault/files/vault.service"


vault:
  service:
    - running
    - order: last
    - enable: True
    - restart: True
