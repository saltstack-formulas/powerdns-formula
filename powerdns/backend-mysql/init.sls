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

