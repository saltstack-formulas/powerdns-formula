{%- set tplroot = tpldir.split('/')[0] %}
{%- from tplroot ~ "/map.jinja" import powerdns with context %}

include:
  - powerdns

powerdns_config:
  file.managed:
    - name: {{ powerdns.config_file }}
    - source: salt://powerdns/files/pdns.conf
    - template: jinja
    - user: {{ powerdns.user }}
    - group: {{ powerdns.group }}
    - mode: '0600'
    - require:
      - pkg: powerdns
    - watch_in:
      - service: powerdns
    - context:
        powerdns: {{ powerdns | json }}
