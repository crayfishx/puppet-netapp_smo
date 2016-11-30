require 'spec_helper'
describe 'netapp_smo' do

  let(:facts) {{ 
    :osfamily => "RedHat",
    :operatingsystemmajrelease => "7",
    :path => '/usr/local/sbin:/usr/local/bin:/sbin:/bin:/usr/sbin:/usr/bin:/opt/puppetlabs/bin:/root/bin'
  }}

  context 'when supplying a version' do
    let(:params) {{
      :version => '3.4.1',
      :source_uri => 'http://content/path'
    }}

    it { is_expected.to contain_class('netapp_smo') }

    it do
      is_expected.to contain_archive("/tmp/netapp.smo.linux-x64-3.4.1.bin").with(
        :extract => false,
        :cleanup => false,
        :source  => "http://content/path/netapp.smo.linux-x64-3.4.1.bin",
        :creates => "/opt/NetApp/smo"
      ).that_comes_before('Exec[smo::install]')
    end

    it do
      is_expected.to contain_file("/tmp/netapp.smo.linux-x64-3.4.1.bin").with(
        :ensure => :absent,
        :backup => false
      ).that_requires('Exec[smo::install]')
    end

    it do
      is_expected.to contain_exec('smo::install').with(
        :command => "chmod 775 /tmp/netapp.smo.linux-x64-3.4.1.bin; /tmp/netapp.smo.linux-x64-3.4.1.bin -i silent",
        :creates => "/opt/NetApp/smo"
      )
    end

    it do
      is_expected.to contain_service('netapp-smo').with(
        :ensure => :running
      ).that_requires('Exec[smo::install]')
    end

    it do
      is_expected.to contain_systemd__unit_file('netapp-smo.service').that_comes_before('Service[netapp-smo]')
    end
        
  end

  context 'when supplying a filename' do
    let(:params) {{
      :installer_filename => 'netapp.smo-installer.bin',
      :source_uri => 'http://content/path'
    }}

    it do
      is_expected.to contain_archive("/tmp/netapp.smo-installer.bin").with(
        :extract => false,
        :cleanup => false,
        :source  => "http://content/path/netapp.smo-installer.bin",
        :creates => "/opt/NetApp/smo"
      ).that_comes_before('Exec[smo::install]')
    end

    it do
      is_expected.to contain_file("/tmp/netapp.smo-installer.bin").with(
        :ensure => :absent,
        :backup => false
      ).that_requires('Exec[smo::install]')
    end

    it do
      is_expected.to contain_exec('smo::install').with(
        :command => "chmod 775 /tmp/netapp.smo-installer.bin; /tmp/netapp.smo-installer.bin -i silent",
        :creates => "/opt/NetApp/smo"
      )
    end
  end

  context "when neither version or filename are supplied" do
    let(:params) {{ :source_uri => 'http://content/path' }}
    it do
      is_expected.to raise_error(/If version is not provided, a filename must be given/)
    end
  end

  context "upgradable" do
    let(:params) {{
      :version => '3.4.1',
      :source_uri => 'http://content/path',
      :upgradable => true,
    }}

    it do
      is_expected.to contain_file('/opt/NetApp/smo/.puppet').with(
        :ensure => :directory
      ).that_requires('Exec[smo::install]')
    end

    it do
      is_expected.to contain_file('/opt/NetApp/smo/.puppet/version-3.4.1').with(
        :ensure => :file,
        :content => /This file is needed by Puppet/,
      ).that_requires('Exec[smo::install]')
    end

    it do
      is_expected.to contain_exec('netapp_smo::service_stop').with(
        :command => 'systemctl stop netapp-smo',
        :creates => '/opt/NetApp/smo/.puppet/version-3.4.1',
      ).that_comes_before('Exec[smo::install]')
    end

    it do
      is_expected.to contain_archive("/tmp/netapp.smo.linux-x64-3.4.1.bin").with(
        :creates => "/opt/NetApp/smo/.puppet/version-3.4.1"
      )
    end

    it do
      is_expected.to contain_exec('smo::install').with(
        :creates => "/opt/NetApp/smo/.puppet/version-3.4.1"
      )
    end
  end

  context "upgradable without version" do
    let(:params) {{
      :source_uri => 'http://content/path',
      :installer_filename   => 'netapp-installer.bin',
      :upgradable => true,
    }}

    it do
      is_expected.to raise_error(/Must specify a version/)
    end

  end

  context 'on Solaris' do
    let(:facts) {{ 
      :osfamily => "Solaris",
      :operatingsystemmajrelease => "11",
      :path => '/usr/local/sbin:/usr/local/bin:/sbin:/bin:/usr/sbin:/usr/bin:/opt/puppetlabs/bin:/root/bin'
    }}
    let(:params) {{
      :version => '3.4.1',
      :system_type => 'solaris',
      :source_uri => 'http://content/path'
    }}

    it do
      is_expected.to contain_archive("/tmp/netapp.smo.solaris-x64-3.4.1.bin").with(
        :creates => "/opt/NTAPsmo/smo"
      )
    end

    it do
      is_expected.to contain_file("/tmp/netapp.smo.solaris-x64-3.4.1.bin").with(
        :ensure => :absent,
        :backup => false
      ).that_requires('Exec[smo::install]')
    end

    it do
      is_expected.to contain_exec('smo::install').with(
        :command => "chmod 775 /tmp/netapp.smo.solaris-x64-3.4.1.bin; /tmp/netapp.smo.solaris-x64-3.4.1.bin -i silent",
        :creates => "/opt/NTAPsmo/smo"
      )
    end

    it do
      is_expected.not_to contain_systemd__unit_file('netapp-smo.service')
    end

    it do
      is_expected.to contain_service('netapp-smo').with(
        :ensure => :running
      ).that_requires('Exec[smo::install]')
    end
  end

end
