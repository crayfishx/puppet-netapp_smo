# == Class: smo
#
# Puppet module to manage SnapManager for Oracle
#
# === Parameters
#
#
# [*source_path*]
#   Path to find the installation binary (eg: puppet:///modules/smo)
#
# [*version*]
#   Version of SMO to install
#
# [*manage_installer*]
#   True or false, whether to manage the installer binary, if set to
#   false then the binary must exist on the system
#
# [*installer_path*]
#   Path where the installer binary is to be found, if manage_installer is set to
#   true then the module will create this folder and download the binary to it
#
# [*system_type*]
#   The system type we are installing, default: linux
#
# [*system_arch*]
#   The system arch we are installing, default: x64
#
# [*installer_filename*]
#   If version, arch and system_type are set then the installer filename 
#   will be determined automatically, but can be overridden here.
#
# === Examples
#
#  class { 'netapp_smo':
#    version     => '3.4',
#    source_path => 'puppet:///binaries/smo',
#  }
#
# === Authors
#
# Craig Dunn <craig@craigdunn.org>
#
# === Copyright
#
# Copyright 2016 Craig Dunn
#
class netapp_smo (
  $source_uri            = undef,
  $version               = undef,
  $manage_installer      = $::netapp_smo::params::manage_installer,
  $installer_path        = $::netapp_smo::params::installer_path,
  $system_type           = $::netapp_smo::params::system_type,
  $system_arch           = $::netapp_smo::params::system_arch,
  $smo_root              = $::netapp_smo::params::smo_root,
  $manage_systemd        = $::netapp_smo::params::manage_systemd,
  $manage_installer_path = $::netapp_smo::params::manage_installer_path,
  $manage_service        = $::netapp_smo::params::manage_service,
  $service_status        = $::netapp_smo::params::service_status,
  $service_start         = $::netapp_smo::params::service_start,
  $service_stop          = $::netapp_smo::params::service_stop,
  $service_hasrestart    = $::netapp_smo::params::service_hasrestart,
  $installer_filename    = undef,
  $properties            = {},
) inherits netapp_smo::params {


  if $installer_filename {
    $filename = $installer_filename
  } else {
    if $version {
      $filename = "netapp.smo.${system_type}-${system_arch}-${version}.bin"
    } else {
      fail('If version is not provided, a filename must be given.')
    }
  }

  if $manage_installer {
    if ( !$source_uri ) {
      fail('If manage_installer is true then a source_uri must be provided')
    }

    if $manage_installer_path {
      file { $installer_path:
        ensure => directory,
      }
    }
  
    archive { "${installer_path}/${filename}":
      ensure          => present,
      extract         => false,
      cleanup         => false,
      source          => "${source_uri}/${filename}",
      creates         => "${smo_root}/smo",
      before          => Exec['smo::install'],
    }

    ## Clean up the installer file once the install has completed.
    file { "${installer_path}/${filename}":
      ensure  => absent,
      backup  => false,
      require => Exec['smo::install'],
    }
  }

  
  # We chmod the file first because we already have a file resource
  # managing the installer to clean up after.
  #
  exec { 'smo::install':
    path    => '/usr/local/sbin:/sbin:/bin:/usr/sbin:/usr/bin',
    command => "chmod 775 ${installer_path}/${filename}; ${installer_path}/${filename} -i silent",
    creates => "${smo_root}/smo",
  }

  create_resources('netapp_smo::property', $properties)
  Exec['smo::install'] -> Netapp_smo::Property <||>

  if $manage_systemd {
    systemd::unit_file { 'netapp-smo.service':
      content => template('netapp_smo/netapp-smo.service.erb'),
      before  => Service['netapp-smo']
    }
  }


  if $manage_service {
    service { $service_name:
      ensure     => running,
      start      => $service_start,
      stop       => $service_stop,
      status     => $service_status,
      hasrestart => $service_hasrestart,
      require    => Exec['smo::install'],
    }
    Netapp_smo::Property<||> -> Service[$service_name]
  }
  
}
