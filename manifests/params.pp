class netapp_smo::params {

  $manage_installer      = true
  $installer_path        = '/tmp'
  $system_type           = 'linux'
  $system_arch           = 'x64'
  $manage_installer_path = false
  $manage_service        = true
  $service_name          = 'netapp-smo'
  $service_stop          = undef
  $service_start         = undef
  $service_hasrestart    = undef

  $smo_root = $::osfamily ? {
    'Solaris' => '/opt/NTAPsmo',
    default   => '/opt/NetApp'
  }

  if ( $::osfamily == 'Redhat' and $::operatingsystemmajrelease == '7' ) {
    $manage_systemd = true
  } else {
    $manage_systemd = false
  }

}




