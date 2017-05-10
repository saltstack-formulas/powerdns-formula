{% from "powerdns/map.jinja" import powerdns with context %}

include:
  - powerdns

powerdns_backend_sqlite3:
  pkg.installed:
    - name: {{ powerdns.lookup.backend_sqlite3_pkg }}
    - require:
      - pkg: powerdns

#/var/lib/powerdns:
{{ salt.file.dirname(powerdns.config['gsqlite3-database']) }}:
  file.directory:
    - user: pdns
    - group: pdns
    - require:
      - pkg: powerdns_backend_sqlite3

powerdns_init_db:
  cmd.run:
    - name: sqlite3 {{ powerdns.config['gsqlite3-database'] }} < /usr/share/doc/pdns-backend-sqlite3/schema.sqlite3.sql
    - creates: {{ powerdns.config['gsqlite3-database'] }}
    - require:
      - pkg: powerdns_backend_sqlite3
      - file: /var/lib/powerdns

{{ powerdns.config['gsqlite3-database'] }}:
  file.managed:
    - user: pdns
    - group: pdns
    - require:
      - cmd: powerdns_init_db

