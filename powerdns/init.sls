{% set powerdns = pillar.get('powerdns', {}) -%}
{% set package = powerdns.get('package', {}) -%}
{% set service = powerdns.get('service', {}) -%}


{% set powerdns = pillar.get('powerdns', {}) -%}
{% set config_path = powerdns.get('config_path', {}) -%}



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
    - name: {{ config_path }}
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