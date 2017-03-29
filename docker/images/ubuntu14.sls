ubuntu14 builder:
  cmd.run:
    - name: docker build -t registry.service.consul:5000/vpp/ubuntu14 .
    - cwd: /root/docker/ubuntu14

ubuntu14 pusher:
  cmd.run:
    - name: docker push registry.service.consul:5000/vpp/ubuntu14
    - require:
      - cmd: ubuntu14 builder

