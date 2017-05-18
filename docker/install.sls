/etc/apt/sources.list.d/docker.list:
  file.managed:
    - source: salt://docker/files/docker.list
  cmd.wait:
    - name: apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys 36A1D7869245C8950F966E92D8576A8BA88D21E9
    - cwd: /tmp
    - watch:
      - file: /etc/apt/sources.list.d/docker.list

docker key way:
  cmd.run:
    - name: curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
    - require:
      - pkg: curl

docker-ce:
  pkg.installed:
    - refresh: true
    - require:
      - file: /etc/apt/sources.list.d/docker.list

apt-transport-https:
  pkg.installed:
    - refresh: false

ca-certificates:
  pkg.installed:
    - refresh: false

software-properties-common:
  pkg.installed:
    - refresh: false

curl:
  pkg.installed:
    - refresh: false

/lib/systemd/system/docker.service:
  file.managed:
    - source: "salt://docker/files/docker.service"
    - template: jinja

docker:
  service.running:
    - enable: True
    - watch:
      - file: /lib/systemd/system/docker.service

