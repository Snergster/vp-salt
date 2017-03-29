/root/jenkins/jenkins.nomad:
  file.managed:
    - source: salt://hashi/nomad/jobs/jenkins.nomad
    - template: jinja
  cmd.run:
    - name: nomad /root/registry/jenkins.nomad

