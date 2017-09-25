/root/fabio/fabio.nomad:
  file.managed:
    - source: salt://hashi/nomad/jobs/fabio.nomad
    - makedirs: True

golang:
  pkg.installed:
    - name: golang

plan the fabio nomad job:
  cmd.run:
    - name: nomad run /root/fabio/fabio.nomad

