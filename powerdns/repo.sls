{% from "powerdns/map.jinja" import powerdns with context %}

powerdns_server_repo:
  pkgrepo.managed:
    - humanname: PowerDNS
    {% if salt['grains.get']('os_family') == 'Debian' %}
    - key_url: {{ powerdns.repo_stable_key_url }}
    {% if (salt['grains.get']('osfullname') == "Ubuntu" and salt['grains.get']('osmajorrelease') < 22)
    or (salt['grains.get']('osfullname') == "Debian" and salt['grains.get']('osmajorrelease') < 12) %}
    - keyid: {{ powerdns.repo.keyid }}
    - keyserver: keyserver.ubuntu.com
    {% endif %}
    - aptkey: {{ powerdns.repo_aptkey }}
      {%   set repo = 'deb [arch=amd64 {3}] https://repo.powerdns.com/{0} {1}-auth-{2} main'.format(
            salt['grains.get']('os').lower(),
            salt['grains.get']('oscodename'),
            powerdns.repo.release,
            powerdns.repo_signedby
      ) %}
    - name: {{ repo }}
    - file: /etc/apt/sources.list.d/powerdns.list
    - clean_file : True

    {% endif  %}
