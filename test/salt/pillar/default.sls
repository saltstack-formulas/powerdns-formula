# -*- coding: utf-8 -*-
# vim: ft=yaml
---
powerdns:
  repo:
    release: master
    keyid: FF389421CBC8B383

  config:
    allow-axfr-ips: '127.0.0.0/8,::1'
    api: 'yes'
    api-key: d34db33f
    gsqlite3-database: /var/lib/powerdns/pdns.sqlite3
    gsqlite3-dnssec: 'yes'
    launch: gsqlite3
    webserver: 'yes'
    webserver-port: 8081
