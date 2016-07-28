{% from "powerdns/map.jinja" import powerdns with context %}

include:
  - powerdns

powerdns_backend_mysql:
  pkg.installed:
    - name: {{ powerdns.lookup.backend_mysql_pkg }}
    - require:
      - pkg: powerdns
