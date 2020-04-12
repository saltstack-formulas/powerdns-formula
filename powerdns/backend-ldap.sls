{%- set tplroot = tpldir.split('/')[0] %}
{%- from tplroot ~ "/map.jinja" import powerdns with context %}

include:
  - {{ tplroot }}

powerdns_backend_ldap:
  pkg.installed:
    - name: {{ powerdns.backend_ldap_pkg }}
    - require:
      - pkg: powerdns
