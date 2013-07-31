{% set powerdns = pillar.get('powerdns', {}) -%}
{% set package = powerdns.get('package', {}) -%}
{% set service = powerdns.get('service', {}) -%}
{% set config = powerdns.get('config', {}) -%}
{% set config_file = config.get('file', {}) -%}

powerdns:
  pkg.installed:
    - name: {{ package.get('name') }}
    - version: {{ package.get('version') }}

  service.running:
    - name: {{ service }}
    - require:
      - pkg: powerdns

powerdns_config:
  file.managed:
    - name: {{ config_file }}
    - source: salt://powerdns/config/pdns.conf
    - template: jinja
    - user: root
    - group: root
    - mode: 600
    - require:
      - pkg: powerdns

extend:
  powerdns:
    service:
      - running
      - reload: True
      - watch:
        - file: powerdns_config
