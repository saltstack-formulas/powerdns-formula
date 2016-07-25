{% from "powerdns/map.jinja" import powerdns with context %}

include:
  - powerdns

{% if salt['grains.get']('os_family') == 'Debian' %}

powerdns_server_repo:
  pkgrepo.managed:
    - humanname: PowerDNS
    - name: deb [arch=amd64] https://repo.powerdns.com/{{ salt['grains.get']('os').lower() }} {{ salt['grains.get']('oscodename') }}-auth-{{ powerdns.repo.release }} main
    - file: /etc/apt/sources.list.d/powerdns.list
    - keyid: {{ powerdns.repo.keyid }}
    - keyserver: keys.gnupg.net
    - require_in:
      - pkg: powerdns

{% elif salt['grains.get']('os_family') == 'RedHat' %}
{# TODO: add RHEL/CentOS support #}
{% endif %}
