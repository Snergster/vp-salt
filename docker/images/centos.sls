centos builder:
  cmd.run:
    - name: docker build -t registry.service.consul:5000/vpp/centos .
    - cwd: /root/docker/centos

centos pusher:
  cmd.run:
    - name: docker push registry.service.consul:5000/vpp/centos
    - require:
      - cmd: centos builder

