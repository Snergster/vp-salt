include:
  - hashi.consul.install
  - hashi.consul.user

consul enabled:
  service.enabled:
    - name: consul
    - order: last
    - enable: True
    - restart: True

consul running:
  service.running:
    - name: consul
    - order: last
    - enable: True
    - restart: True

consul service restart:
  cmd.run:
    - name: service consul start

consul service enabled:
  cmd.run:
    - name: systemctl enable consul
    - require:
      - file: /etc/systemd/system/consul.service

