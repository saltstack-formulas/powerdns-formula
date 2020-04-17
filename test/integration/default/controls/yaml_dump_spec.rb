# frozen_string_literal: true

control 'PowerDNS `map.jinja` YAML dump' do
  title 'should contain the lines'

  yaml_dump = "---\n"
  yaml_dump +=
    case platform[:family]
    when 'debian'
      <<~YAML_DUMP.chomp
        arch: amd64
        backend_geoip_pkg: pdns-backend-geoip
        backend_ldap_pkg: pdns-backend-ldap
        backend_lua_pkg: pdns-backend-lua
        backend_mydns_pkg: pdns-backend-mydns
        backend_mysql_pkg: pdns-backend-mysql
        backend_odbc_pkg: pdns-backend-odbc
        backend_opendbx_pkg: pdns-backend-opendbx
        backend_pgsql_pkg: pdns-backend-pgsql
        backend_pipe_pkg: pdns-backend-pipe
        backend_remote_pkg: pdns-backend-remote
        backend_sqlite3_pkg: pdns-backend-sqlite3
        backend_sqlite3_pkg_sql: /usr/share/doc/pdns-backend-sqlite3/schema.sqlite3.sql
        config:
          allow-axfr-ips: 127.0.0.0/8,::1
          api: 'yes'
          api-key: d34db33f
          config-dir: /etc/powerdns
          gsqlite3-database: /var/lib/powerdns/pdns.sqlite3
          gsqlite3-dnssec: 'yes'
          launch: gsqlite3
          setgid: pdns
          setuid: pdns
          webserver: 'yes'
          webserver-port: 8081
        config_file: /etc/powerdns/pdns.conf
        group: pdns
        pkg: pdns-server
        repo:
          keyid: FF389421CBC8B383
          release: master
        service: pdns
        sqlite3_pkg: sqlite3
        user: pdns
      YAML_DUMP
    when 'redhat', 'fedora'
      <<~YAML_DUMP.chomp
        arch: amd64
        backend_geoip_pkg: pdns-backend-geoip
        backend_ldap_pkg: pdns-backend-ldap
        backend_lua_pkg: pdns-backend-lua
        backend_mydns_pkg: pdns-backend-mydns
        backend_mysql_pkg: pdns-backend-mysql
        backend_odbc_pkg: pdns-backend-odbc
        backend_opendbx_pkg: pdns-backend-opendbx
        backend_pgsql_pkg: pdns-backend-pgsql
        backend_pipe_pkg: pdns-backend-pipe
        backend_remote_pkg: pdns-backend-remote
        backend_sqlite3_pkg: pdns-backend-sqlite
        backend_sqlite3_pkg_sql: /usr/share/doc/packages/pdns/schema.sqlite3.sql
        config:
          allow-axfr-ips: 127.0.0.0/8,::1
          api: 'yes'
          api-key: d34db33f
          daemon: 'no'
          gsqlite3-database: /var/lib/powerdns/pdns.sqlite3
          gsqlite3-dnssec: 'yes'
          guardian: 'no'
          launch: gsqlite3
          setgid: pdns
          setuid: pdns
          webserver: 'yes'
          webserver-port: 8081
        config_file: /etc/pdns/pdns.conf
        group: pdns
        pkg: pdns
        repo:
          keyid: FF389421CBC8B383
          release: master
        service: pdns
        sqlite3_pkg: sqlite
        user: pdns
      YAML_DUMP
    when 'suse'
      <<~YAML_DUMP.chomp
        arch: amd64
        backend_geoip_pkg: pdns-backend-geoip
        backend_ldap_pkg: pdns-backend-ldap
        backend_lua_pkg: pdns-backend-lua
        backend_mydns_pkg: pdns-backend-mydns
        backend_mysql_pkg: pdns-backend-mysql
        backend_odbc_pkg: pdns-backend-odbc
        backend_opendbx_pkg: pdns-backend-opendbx
        backend_pgsql_pkg: pdns-backend-pgsql
        backend_pipe_pkg: pdns-backend-pipe
        backend_remote_pkg: pdns-backend-remote
        backend_sqlite3_pkg: pdns-backend-sqlite3
        backend_sqlite3_pkg_sql: /usr/share/doc/packages/pdns/schema.sqlite3.sql
        config:
          allow-axfr-ips: 127.0.0.0/8,::1
          api: 'yes'
          api-key: d34db33f
          gsqlite3-database: /var/lib/powerdns/pdns.sqlite3
          gsqlite3-dnssec: 'yes'
          launch: gsqlite3
          webserver: 'yes'
          webserver-port: 8081
        config_file: /etc/pdns/pdns.conf
        group: pdns
        pkg: pdns
        repo:
          keyid: FF389421CBC8B383
          release: master
        service: pdns
        sqlite3_pkg: sqlite3
        user: pdns
      YAML_DUMP
    end

  describe file('/tmp/salt_yaml_dump.yaml') do
    its('content') { should include yaml_dump }
  end
end
