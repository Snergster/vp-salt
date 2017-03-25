/root/registry/registry.nomad:
  file.managed:
    - source: salt://hashi/nomad/jobs/registry.nomad
  cmd.run:
    - name: nomad /root/registry/registry.nomad

