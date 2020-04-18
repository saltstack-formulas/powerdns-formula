# frozen_string_literal: true

control 'PowerDNS service' do
  impact 0.5
  title 'should be installed, enabled and running'

  describe service('pdns') do
    it { should be_installed }
    it { should be_enabled }
    it { should be_running }
  end
end
