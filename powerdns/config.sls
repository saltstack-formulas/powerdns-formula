{% from "powerdns/map.jinja" import powerdns with context %}

include:
  - powerdns

powerdns_config:
  file.managed:
    - name: {{ powerdns.lookup.config_file }}
    - source: salt://powerdns/files/pdns.conf
    - template: jinja
    - user: root
    - group: root
    - mode: 600
    - require:
      - pkg: powerdns
    - watch_in:
      - service: powerdns
