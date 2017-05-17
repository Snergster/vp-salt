dnsmasq package install:
  pkg.installed:
    - name: dnsmasq
    - refresh: false

dnsmasq replace:
  file.prepend:
    - name: /etc/dnsmasq.conf
    - text: resolv-file=/etc/resolv.conf.dnsmasq

dnsmasq resolv version:
  file.copy:
    - name: /etc/resolv.conf.dnsmasq
    - source: /etc/resolv.conf

consul into dns:
  file.managed:
    - name: /etc/resolv.conf
    - contents: nameserver 127.0.0.1
    - require:
      - pkg: dnsmasq
      - file: dnsmasq resolv version

default nameserver dnsmasq:
  file.replace:
    - name: /etc/network/interfaces
    - pattern: dns-nameservers .*
    - repl: dns-nameservers 127.0.0.1
    - require:
      - pkg: dnsmasq
      - file: dnsmasq resolv version

dnsmasq enabled:
  service.enabled:
    - name: dnsmasq

dnsmasq:
  service:
    - running
    - order: last
    - enable: True
    - restart: True
