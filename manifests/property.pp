# Define a property in the smo.config file
define netapp_smo::property (
  $ensure = 'present',
  $value  = undef,
) {

  ini_setting { "netapp_smo::property::${name}":
    ensure            => $ensure,
    path              => "${::netapp_smo::smo_root}/smo/properties/smo.config",
    section           => '',
    key_val_separator => '=',
    setting           => $name,
    value             => $value,
  }
}



