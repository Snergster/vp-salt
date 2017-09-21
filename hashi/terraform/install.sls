

/var/cache/salt/terraform.zip:
  file.managed:
    - source: https://releases.hashicorp.com/terraform/0.10.6/terraform_0.10.6_linux_amd64.zip
    - source_hash: https://releases.hashicorp.com/terraform/0.10.6/terraform_0.10.6_SHA256SUMS
  module.run:
    - name: archive.unzip
    - zip_file: /var/cache/salt/terraform.zip
    - dest: /usr/local/bin

/usr/local/bin/terraform:
  file.managed:
    - mode: 0755
    - onchanges:
      - module: /var/cache/salt/terraform.zip
