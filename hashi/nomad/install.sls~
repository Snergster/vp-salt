
{% set crypt = salt['pillar.get']('restrictedusers:consul:crypt', salt['grains.get']('consul_crypt', '$6rUu5wzdNP0Y')) %}

/var/cache/salt/consul.zip:
  file.managed:
    - source: https://releases.hashicorp.com/consul/0.7.5/consul_0.7.5_linux_amd64.zip
    - source_hash: 40ce7175535551882ecdff21fdd276cef6eaab96be8a8260e0599fadb6f1f5b8
  service.dead:
    - names:
      - consul
  module.run:
    - name: archive.unzip
    - zip_file: /var/cache/salt/consul.zip
    - dest: /usr/local/bin


/usr/local/bin/consul:
  file.managed:
    - mode: 0755
    - onchanges:
      - module: /var/cache/salt/consul.zip

consul group:
  group.present:
    - name: consul

consul user:
  user.present:
    - name: consul
    - require:
      - group: consul group
    - fullname: Consul user
    - shell: /bin/bash
    - home: /home/consul
    - groups:
      - consul
    - password: {{ crypt }}

{% for consuldir in ['/etc/consul.d/bootstrap','/etc/consul.d/server','/etc/consul.d/client','/var/consul','/etc/consul.d/ssl/CA'] %}
{{consuldir}}:
  file.directory:
    - require:
      - user: consul user
    - user: consul
    - group: consul
    - makedirs: True

{% endfor %}

python-consul for salt-consul:
  pip.installed:
    - name: python-consul
    {% if proxy == true %}
    - proxy: {{ http_proxy }}
    {% endif %}


/etc/consul.d/ssl/ca.cert:
  file.managed:
    - contents_pillar: consul:cacert
    - user: consul
    - group: consul

/etc/consul.d/ssl/consul.cert:
  file.managed:
    - contents_pillar: consul:sslcert
    - user: consul
    - group: consul

/etc/salt/minion.d/consul.conf:
  file.managed:
    - source: "salt://common/consul/files/consul.conf"
    - template: jinja

/etc/consul.d/ssl/consul.key:
  file.managed:
    - contents_pillar: consul:sslkey
    - user: consul
    - group: consul

consul:
  service:
    - running
    - order: last
    - enable: True
    - restart: True
