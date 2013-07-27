{% set powerdns-mysql = pillar.get('powerdns-backend-mysql', {}) -%}
{% set package = powerdns-mysql.get('package', {}) -%}
{% set name = package.get('name', {}) -%}
{% set version = package.get('version', {}) -%}

{% set mysql = powerdns-mysql.get('mysql', {}) -%}
{% set user = mysql.get('user', {}) -%}
{% set host = mysql.get('host', {}) -%}
{% set pass = mysql.get('pass', {}) -%}
{% set pass_hash = mysql.get('pass_hash', {}) -%}

{% set powerdns = pillar.get('powerdns', {}) -%}
{% set config_path = powerdns.get('config_path_local', {}) -%}



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