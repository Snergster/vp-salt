/root/registry/registry.nomad:
  file.managed:
    - source: salt://hashi/nomad/jobs/registry.nomad
    - makedirs: True
    - template: jinja
  cmd.run:
    - name: nomad /root/registry/registry.nomad

