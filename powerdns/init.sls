{%- set tplroot = tpldir.split('/')[0] %}
{%- from tplroot ~ "/map.jinja" import powerdns with context %}

{% set os_family = salt['grains.get']('os_family') %}

{% if os_family in ['Debian'] %}
include:
  - powerdns.repo
{% endif %}

powerdns:
  pkg.installed:
    - name: {{ powerdns.pkg }}
    - refresh_db: True
    {% if os_family in ['Debian'] %}
    - require:
      - sls: powerdns.repo
    {% endif %}

  service.running:
    - name: {{ powerdns.service }}
    - enable: True
    - require:
      - pkg: powerdns
