{% from "powerdns/map.jinja" import powerdns with context %}

include:
  - powerdns.repo

powerdns:
  pkg.installed:
    - name: {{ powerdns.lookup.pkg }}
    - refresh_db: True
    - require:
      - sls: powerdns.repo

  service.running:
    - name: {{ powerdns.lookup.service }}
    - enable: True
    - require:
      - pkg: powerdns
