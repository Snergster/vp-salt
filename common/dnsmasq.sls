dnsmasq:
  pkg.installed:
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
  file.prepend:
    - name: /etc/resolv.conf
    - text: nameserver 127.0.0.1
    - require:
      - pkg: dnsmasq
      - file: dnsmasq resolv version

dnsmasq:
  service:
    - running
    - order: last
    - enable: True
    - restart: True
