
{% set crypt = salt['pillar.get']('restrictedusers:consul:crypt', salt['grains.get']('consul_crypt', '$6rUu5wzdNP0Y')) %}
{% set bootstrap = salt['grains.get']('consul_bootstrap', False ) %}
{% set server = salt['grains.get']('consul_server', False ) %}
{% set agent = salt['grains.get']('consul_agent', False ) %}

/var/cache/salt/packer.zip:
  file.managed:
    - source: https://releases.hashicorp.com/packer/1.0.4/packer_1.0.4_linux_amd64.zip
    - source_hash: https://releases.hashicorp.com/packer/1.0.4/packer_1.0.4_SHA256SUMS?_ga=2.81175447.1062380219.1502998978-159452932.1489086946
  module.run:
    - name: archive.unzip
    - zip_file: /var/cache/salt/packer.zip
    - dest: /usr/local/bin


/usr/local/bin/packer:
  file.managed:
    - mode: 0755
    - onchanges:
      - module: /var/cache/salt/packer.zip

