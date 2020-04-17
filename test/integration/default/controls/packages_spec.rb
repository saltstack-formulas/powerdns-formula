# frozen_string_literal: true

# Overide by platform
package_names =
  case platform[:family]
  when 'debian'
    %w[pdns-server pdns-backend-sqlite3]
  when 'redhat', 'fedora'
    %w[pdns pdns-backend-sqlite]
  when 'suse'
    %w[pdns pdns-backend-sqlite3]
  end

control 'PowerDNS packages' do
  title 'should be installed'

  package_names.each do |p|
    describe package(p) do
      it { should be_installed }
    end
  end
end
