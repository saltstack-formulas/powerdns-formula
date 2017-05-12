{% from "powerdns/map.jinja" import powerdns with context %}

{% set os_family = salt['grains.get']('os_family') %}

{% if os_family in ['Debian', 'RedHat'] %}
include:
  - powerdns.repo
{% endif %}

powerdns:
  pkg.installed:
    - name: {{ powerdns.lookup.pkg }}
    - refresh_db: True
    {% if os_family in ['Debian', 'RedHat'] %}
    - require:
      - sls: powerdns.repo
    {% endif %}

  service.running:
    - name: {{ powerdns.lookup.service }}
    - enable: True
    - require:
      - pkg: powerdns
