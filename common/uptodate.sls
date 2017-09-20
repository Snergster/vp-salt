distupgrade:
  pkg.uptodate:
    - refresh: true

autoremove cleanup:
  cmd.run:
    - name: apt-get autoremove -y
