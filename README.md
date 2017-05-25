powerdns
========

Installs a basic PowerDNS authorative server, and enables different backend configurations.

See the full [Salt Formulas installation and usage instructions].

Usage
=====

All the configuration for powerdns is done via pillar (pillar.example).

Available states
================

`powerdns`
----------

Installs PowerDNS authorative server.

`powerdns.repo`
---------------

Installs PowerDNS authorative server from official repostiory.

`powerdns.backend-mysql`
------------------------

Installs PowerDNS MySQL backend package.

`powerdns.backend-sqlite3`
--------------------------

Installs PowerDNS sqlite3 backend package. Initializes sqlite3 db specified in config pillar.

`powerdns.config`
-----------------

Configures PowerDNS authorative server.

`powerdns.api`
--------------

Installes the required pdnsapi python module. Requires pip to work.

To use this module, you need to have the following set either in pillar or your minion config:

```SaltStack

pdns.url: "http://127.0.0.1:8081"
pdns.server_id: "localhost"
pdns.api_key: "deadbeef"
```

