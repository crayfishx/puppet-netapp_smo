define netapp_smo::property (
  $ensure = 'present',
  $value  = undef,
) {

  ini_setting { "netapp_smo::property::${name}":
    path              => "${::netapp_smo::smo_root}/smo/properties/smo.config",
    ensure            => $ensure,
    section           => '',
    key_val_separator => '=',
    setting           => $name,
    value             => $value,
  }
}



