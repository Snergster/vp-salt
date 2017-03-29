ubuntu16 builder:
  cmd.run:
    - name: docker build -t registry.service.consul:5000/vpp/ubuntu16 .
    - cwd: /root/docker/ubuntu16

ubuntu16 pusher:
  cmd.run:
    - name: docker push registry.service.consul:5000/vpp/ubuntu16
    - require:
      - cmd: ubuntu16 builder

