include:
  - common.dnsmasq.install

/etc/dnsmasq.d/10-consul:
  file.managed:
    - source: "salt://hashi/consul/files/10-consul"
    - template: jinja
    - require:
      - pkg: dnsmasq

/etc/dnsmasq.d/20-text:
  file.managed:
    - contents_pillar: consul:letstext
    - require:
      - pkg: dnsmasq


dnsmasq service enabled:
  service.enabled:
    - name: dnsmasq

dnsmasq running:
  service.running:
    - name: dnsmasq
    - enable: True
    - restart: True
