

include:
  - mysql.client

powerdns-mysql:
  pkg.installed:
    - name: {{ name }}
    - version: {{ version }}

powerdns-mysql_db:
  mysql_database.present:
    - name: powerdns
    - require:
      - pkg: powerdns-mysql
      - service: mysql-client


powerdns-mysql_user:
  mysql_user.present:
    - name: {{ user }}
    - host: {{ host }}
    - password_hash: {{ pass_hash }}
    - require:
      - pkg: powerdns-mysql
      - service: mysql-client

powerdns-mysql_grants:
  mysql_grants.present:
    - grant: all privileges
    - database: powerdns
    - user: {{ user }}
    - host: {{ host }} 

powerdns-mysql_config:
  file.managed:
    - name: {{ config_path }}
    - source: salt://powerdns/config/pdns.local
    - template: jinja
    - user: root
    - group: root
    - mode: 600
    - require:
      - pkg: powerdns-mysql