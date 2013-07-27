{% set powerdns = pillar.get('powerdns', {}) -%}

powerdns:
  pkg.installed:
    - name: {{ powerdns.get('package:name') }}
    - version: {{ powerdns.get('package:version') }}

  service.running:
    - name: {{ powerdns.get('service') }}
    - require:
      - pkg: powerdns
