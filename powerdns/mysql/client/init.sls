mysql-client:
  pkg.installed:
    - name: mysql-client
    

  service.running:
    - name: mysql-client
    - require:
      - pkg: mysql-client