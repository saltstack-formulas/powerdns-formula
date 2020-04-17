{%- set tplroot = tpldir.split('/')[0] %}
{%- from tplroot ~ "/map.jinja" import powerdns with context %}

include:
  - powerdns

powerdns_backend_mysql:
  pkg.installed:
    - name: {{ powerdns.backend_mysql_pkg }}
    - require:
      - pkg: powerdns
