

/var/cache/salt/vault.zip:
  file.managed:
    - source: https://releases.hashicorp.com/vault/0.9.1/vault_0.9.1_linux_amd64.zip
    - source_hash: https://releases.hashicorp.com/vault/0.9.1/vault_0.9.1_SHA256SUMS
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

/etc/systemd/system/vault.service:
  file.managed:
    - source: "salt://hashi/vault/files/vault.service"

vault:
  service:
    - running
    - order: last
    - enable: True
    - restart: True
