
liblxc1:
  pkg.installed:
    - refresh: false

/var/cache/salt/nomad.zip:
  file.managed:
    - source: https://releases.hashicorp.com/nomad/0.7.0-beta1/nomad_0.7.0-beta1_linux_amd64.zip
    - source_hash: https://releases.hashicorp.com/nomad/0.7.0-beta1/nomad_0.7.0-beta1_SHA256SUMS
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

nomad:
  service.running:
    - order: last
    - enable: True
    - restart: True

