/root/registry/registry.nomad:
  file.managed:
    - source: salt://hashi/nomad/jobs/registry.nomad
    - template: jinja
  cmd.run:
    - name: nomad /root/registry/registry.nomad

