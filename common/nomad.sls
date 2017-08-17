/root/cache.json:
  file.managed:
    - source: salt://common/files/cache.json
    - makedirs: True
    - mode: 0755

/root/fabio.nomad:
  file.managed:
    - source: salt://common/files/fabio.nomad
    - makedirs: True
    - mode: 0755

/root/jenkins.nomad:
  file.managed:
    - source: salt://common/files/jenkins.nomad
    - makedirs: True
    - mode: 0755

/root/registry.nomad:
  file.managed:
    - source: salt://common/files/registry.nomad
    - makedirs: True
    - mode: 0755

/var/jenkins.tar:
  file.managed:
    - source: salt://common/files/jenkins.tar
    - makedirs: True
    - mode: 0755
