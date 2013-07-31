{% set mysql = config.get('mysql', {}) -%}
{% set database = mysql.get('database', {}) -%}
{% set user = mysql.get('user', {}) -%}
{% set host = mysql.get('host', {}) -%}
{% set pass = mysql.get('pass', {}) -%}
{% set password_hash = mysql.get('password_hash', {}) -%}

{% set config_file = config.get('file', {}) -%}

include:
  - mysql.server
  - mysql.client
  - powerdns

powerdns-backend-mysql:
  pkg.installed:
    - name: {{ name }}
    - version: {{ version }}
    - require:
      - file: powerdns_config
      - service: mysql-server

powerdns-backend-mysql_db:
  mysql_database.present:
    - name: {{ database }}
    - connection_user: root
    - connection_pass: {{ pillar['mysql']['users']['root']['password']['cleartext'] }}
    - require:
      - pkg: powerdns-backend-mysql
      - service: mysql-server
      - mysql_user: mysql_root_user_localhost
      
powerdns-backend-mysql_user:
  mysql_user.present:
    - name: {{ user }}
    - host: {{ host }}
    - password_hash: '{{ password_hash }}'
    - connection_user: root
    - connection_pass: {{ pillar['mysql']['users']['root']['password']['cleartext'] }}
    - require:
      - pkg: powerdns-backend-mysql
      - service: mysql-server
      - mysql_database: powerdns-backend-mysql_db
      

powerdns-backend-mysql_grants:
  mysql_grants.present:
    - grant: all privileges
    - database: {{ database }}.*
    - user: {{ user }}
    - host: {{ host }} 
    - connection_user: root
    - connection_pass: {{ pillar['mysql']['users']['root']['password']['cleartext'] }}
    - require:
      - pkg: powerdns-backend-mysql
      - mysql_user: powerdns-backend-mysql_user
      - mysql_user: mysql_root_user_localhost

powerdns-backend-mysql_config:
  file.managed:
    - name: {{ config_file }}
    - source: salt://powerdns/config/pdns.local
    - template: jinja
    - user: root
    - group: root
    - mode: 600
    - require:
      - pkg: powerdns-backend-mysql

powerdns-backend-mysql_init_script:
  file.managed:
    - name: /tmp/powerdns_mysql_init.sql
    - source: salt://powerdns/config/init.sql
    - user: root
    - group: root
    - mode: 644
    - unless: mysql {{ database }} -u {{ user }} -p{{ pass }} -e "SELECT * FROM domains;"
    - require:
      - file: powerdns-backend-mysql_config
      - pkg: powerdns-backend-mysql
      - pkg: mysql-client
      - mysql_grants: powerdns-backend-mysql_grants

powerdns-backend-mysql_run_script:
  cmd.run:
    - name: mysql {{ database }} -u {{ user }} -p{{ pass }} < /tmp/powerdns_mysql_init.sql
    - require:
      - file: powerdns-backend-mysql_init_script
      - pkg: powerdns-backend-mysql
      - pkg: mysql-client

