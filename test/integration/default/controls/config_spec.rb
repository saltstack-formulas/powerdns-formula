# frozen_string_literal: true

control 'PowerDNS configuration' do
  title 'should be generated properly'

  config_filename =
    case platform[:family]
    when 'debian'
      '/etc/powerdns/pdns.conf'
    else
      '/etc/pdns/pdns.conf'
    end

  config_file =
    case platform[:family]
    when 'debian'
      <<~CONFIG_FILE.chomp
        allow-axfr-ips=127.0.0.0/8,::1
        api=yes
        api-key=d34db33f
        config-dir=/etc/powerdns
        gsqlite3-database=/var/lib/powerdns/pdns.sqlite3
        gsqlite3-dnssec=yes
        launch=gsqlite3
        setgid=pdns
        setuid=pdns
        webserver=yes
        webserver-port=8081
      CONFIG_FILE
    when 'redhat', 'fedora'
      <<~CONFIG_FILE.chomp
        allow-axfr-ips=127.0.0.0/8,::1
        api=yes
        api-key=d34db33f
        daemon=no
        gsqlite3-database=/var/lib/powerdns/pdns.sqlite3
        gsqlite3-dnssec=yes
        guardian=no
        launch=gsqlite3
        setgid=pdns
        setuid=pdns
        webserver=yes
        webserver-port=8081
      CONFIG_FILE
    when 'suse'
      <<~CONFIG_FILE.chomp
        allow-axfr-ips=127.0.0.0/8,::1
        api=yes
        api-key=d34db33f
        gsqlite3-database=/var/lib/powerdns/pdns.sqlite3
        gsqlite3-dnssec=yes
        launch=gsqlite3
        webserver=yes
        webserver-port=8081
      CONFIG_FILE
    end

  describe file(config_filename) do
    it { should be_file }
    it { should be_owned_by 'pdns' }
    it { should be_grouped_into 'pdns' }
    its('mode') { should cmp '0644' }
    its('content') { should include config_file }
  end
end

control 'PowerDNS sqlite3 database configuration' do
  title 'should be generated properly'

  describe file('/var/lib/powerdns/pdns.sqlite3') do
    it { should be_file }
    it { should be_owned_by 'pdns' }
    it { should be_grouped_into 'pdns' }
    its('mode') { should cmp '0644' }
  end
end
