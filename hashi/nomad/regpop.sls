/root/regpop/regpop.nomad:
  file.managed:
    - source: salt://hashi/nomad/jobs/regpop.nomad
    - makedirs: True

/root/regpop/regpop.json:
  file.managed:
    - source: salt://hashi/nomad/jobs/regpop.json
    - makedirs: True

plan the regpop nomad job:
  cmd.run:
    - name: nomad plan /root/regpop/regpop.nomad

