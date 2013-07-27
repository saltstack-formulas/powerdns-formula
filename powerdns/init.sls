{% set powerdns = pillar.get('powerdns', {}) -%}
{% set package = powerdns.get('package', {}) -%}
{% set service = powerdns.get('service', {}) -%}

powerdns:
  pkg.installed:
    - name: {{ package.get('name') }}
    - version: {{ package.get('version') }}

  service.running:
    - name: {{ service }}
    - require:
      - pkg: powerdns
