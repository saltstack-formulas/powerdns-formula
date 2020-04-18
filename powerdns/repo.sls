{% from "powerdns/map.jinja" import powerdns with context %}

powerdns_server_repo:
  pkgrepo.managed:
    - humanname: PowerDNS
    {% if salt['grains.get']('os_family') == 'Debian' %}
    {%   set repo = 'deb [arch=amd64] https://repo.powerdns.com/{0} {1}-auth-{2} main'.format(
            salt['grains.get']('os').lower(),
            salt['grains.get']('oscodename'),
            powerdns.repo.release
          ) %}
    - name: {{ repo }}
    - file: /etc/apt/sources.list.d/powerdns.list
    - keyid: {{ powerdns.repo.keyid }}
    - keyserver: keys.gnupg.net
    {% endif %}
