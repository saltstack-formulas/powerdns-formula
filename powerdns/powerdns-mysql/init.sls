{% set powerdns_mysql = pillar.get('powerdns_backend_mysql', {}) %}
{% set package = powerdns_mysql.get('package', {}) -%}
{% set name = package.get('name', {}) -%}
{% set version = package.get('version', {}) -%}

{% set mysql = powerdns_mysql.get('mysql', {}) -%}
{% set user = mysql.get('user', {}) -%}
{% set host = mysql.get('host', {}) -%}
{% set pass = mysql.get('pass', {}) -%}
{% set pass_hash = mysql.get('pass_hash', {}) -%}

{% set powerdns = pillar.get('powerdns', {}) -%}
{% set config_path = powerdns.get('config_path_local', {}) -%}

powerdns-mysql:
  pkg.installed:
    - name: {{ name }}
    - version: {{ version }}

powerdns-mysql_db:
  mysql_database.present:
    - name: powerdns
    - require:
      - pkg: powerdns-mysql
      


powerdns-mysql_user:
  mysql_user.present:
    - name: {{ user }}
    - host: {{ host }}
    - password_hash: '{{ pass_hash }}'
    - require:
      - pkg: powerdns-mysql
      

powerdns-mysql_grants:
  mysql_grants.present:
    - grant: all privileges
    - database: powerdns.*
    - user: {{ user }}
    - host: {{ host }} 
    - require:
      - mysql_user: powerdns-mysql_user

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


create-tables:
  module.run:
    - name: mysql.query
    - **kwargs: powerdns "CREATE TABLE records (id INT auto_increment,domain_id INT DEFAULT NULL,name VARCHAR(255) DEFAULT NULL,type VARCHAR(6) DEFAULT NULL,content VARCHAR(255) DEFAULT NULL,ttl INT DEFAULT NULL,prio INT DEFAULT NULL,change_date INT DEFAULT NULL,primary key(id), INDEX rec_name_index (name),INDEX nametype_index (name,type),INDEX domain_id (domain_id));"