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
  $source_path        = undef,
  $version            = undef,
  $manage_installer   = true,
  $installer_path     = '/opt/.smo_snapdrive',
  $system_type        = 'linux',
  $system_arch        = 'x64',
  $installer_filename = undef,
  $properties         = {}, 
) {

  $smo_root = $::osfamily ? {
    'Solaris' => '/opt/NTAPsmo',
    default   => '/opt/NetApp'
  }


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
    file { $installer_path:
      ensure => directory,
    }
  
    file { "${installer_path}/${filename}":
      ensure => file,
      mode   => '0755',
      source => "${source_path}/${filename}",
      before => Exec['smo::install'],
    }
  }

  create_resources('netapp_smo::property', $properties)


  
  exec { 'smo::install':
    path    => '/usr/local/sbin:/sbin:/bin:/usr/sbin:/usr/bin',
    command => "${installer_path}/${filename} -i silent",
    creates => "${smo_root}/smo",
  }

  service { 'netapp.smo':
    ensure     => running,
    start      => "${smo_root}/smo/bin/smo_server start",
    stop       => "${smo_root}/smo/bin/smo_server stop",
    status     => "${smo_root}/smo/bin/smo_server status",
    hasrestart => false,
    provider   => 'base',
    require    => Exec['smo::install'],
  }
  
}
