{%- set tplroot = tpldir.split('/')[0] %}
{%- from tplroot ~ "/map.jinja" import powerdns with context %}

include:
  - powerdns

powerdns_backend_sqlite3:
  pkg.installed:
    - pkgs:
      - {{ powerdns.sqlite3_pkg }}
      - {{ powerdns.backend_sqlite3_pkg }}
    - require:
      - pkg: powerdns

#/var/lib/powerdns:
{{ salt.file.dirname(powerdns.config['gsqlite3-database']) }}:
  file.directory:
    - user: {{ powerdns.user }}
    - group: {{ powerdns.group }}
    - require:
      - pkg: powerdns_backend_sqlite3

powerdns_init_db:
  file.managed:
    - name: {{ powerdns.backend_sqlite3_pkg_sql }}
    - source: salt://powerdns/files/schema.sqlite3.sql
    - makedirs: True
    # If the schema is already present, do not replace it
    # (i.e. use that instead of the schema provided by the formula)
    - replace: False
    - require:
      - pkg: powerdns_backend_sqlite3
    - require_in:
      - cmd: powerdns_init_db
  cmd.run:
    - name: sqlite3 {{ powerdns.config['gsqlite3-database'] }} < {{ powerdns.backend_sqlite3_pkg_sql }}
    - creates: {{ powerdns.config['gsqlite3-database'] }}
    - require:
      - pkg: powerdns_backend_sqlite3
      - file: {{ salt.file.dirname(powerdns.config['gsqlite3-database']) }}

{{ powerdns.config['gsqlite3-database'] }}:
  file.managed:
    - user: {{ powerdns.user }}
    - group: {{ powerdns.group }}
    - require:
      - cmd: powerdns_init_db
    - watch_in:
      - service: {{ powerdns.service }}
