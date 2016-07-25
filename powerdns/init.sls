{% from "powerdns/map.jinja" import powerdns with context %}

powerdns:
  pkg.installed:
    - name: {{ powerdns.lookup.pkg }}
    - refresh_db: True

  service.running:
    - name: {{ powerdns.lookup.service }}
    - enable: True
    - require:
      - pkg: powerdns
