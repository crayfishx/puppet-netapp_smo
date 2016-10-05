# netapp_smo


## Introduction 

This module manages the SnapManager for Oracle package.

## Packaging

The SMO package comes as a binary self-contained executable installer that supports a silent running mode.  The .bin file must already exist, or be downloaded from a specified source URI (http://, file://, ftp://, s3://...).

# Example

```
    class { 'netapp_smo':
      version     => '3.4',
      source_uri  => 'http://content.mycorp.com/archives/netapp_smo'
    }
```

# Configuration

## Class: netapp_smo

### Parameters

`source_uri`:
Path to find the folder containing the installation binary (eg: puppet:///modules/smo).  The source URI should be the containing folder for `installer_filename`

`version`: (optional)
Version of SMO to install

`manage_installer`: (optional, boolean)
True or false, whether to manage the installer binary, if set to false then the binary must exist on the system. If `manage_installer` is true then a `source_uri` must be supplied.

`installer_path`: (optional)
Path where the installer binary is to be found, if manage_installer is set to true then the module will download the binary file here (it is deleted after install).  default: /tmp

`manage_installer_path`: (optional, boolean)
Whether or not to try and manage/create the `installer_path`, default: false

`installer_filename`: (optional)
If version, arch and system_type are set then the installer filename will be determined automatically, but can be overridden here.  

`manage_systemd`: (optional, boolean)
Whether or not to manage the systemd unit file.  Defaults to `true` on RedHat 7 derivitives and `false` on others

`manage_service`: (optional, boolean)
Whether or not to try and manage the service

`service_name`: (optional)
Name of the service, default: netapp-smo

`service_start`: (optional)
Specify a custom start command for the service if `manage_service` is true, default: undef

`service_stop`: (optional)
Specify a custom stop command for the service if `manage_service` is true, default: undef

`service_status`: (optional)
Specify a custom status  command for the service if `manage_service` is true, default: undef

`service_hasrestart`: (optional, boolean)
Whether or not the service has a restart capability, default: undef

`system_type`: (optional)
The system type we are installing, used for autodetermining the `installer_filename`. default: linux

`system_arch`: (optional)
The system arch we are installing, used for autodetermining the `installer_filename`. default: x64

`smo_root`: (optional)
The location of the snapmanager binaries, defaults to `/opt/NetApp`, or `/opt/NTAPsmo` on Solaris

`properties`: (optional, hash)
A hash of `netapp_smo::property` types to configure. (see below)

### Service

If you are running on systemd it is advisable to use the systemd script provided by enabling `manage_systemd` to avoid problems with the SMO service sharing the same scope as Puppet and therefore stopped when Puppet is stopped. 

If you are _not_ using systemd then you will probably need to specify how to start and stop the service, eg:

```puppet
class { 'netapp_smo':
  ...
  service_hasrestart => false,
  service_start      => '/opt/NetApp/smo/bin/smo_server start',
  service_stop       => '/opt/NetApp/smo/bin/smo_server stop',
  service_status     => '/opt/NetApp/smo/bin/smo_server status',
}
```


## Defined resource type: netapp_smo::property

Configures properties in the `<smo_root>/smo/properties/smo.config` file

The resource title corresponds to the name of the setting.

### Parameters

`ensure`: (optional)  Default to present
`value`: Value to configure


## Author

* Written and maintained by Craig Dunn <craig@craigdunn.org> @crayfishx
* Sponsered by Baloise Group [http://baloise.github.io](http://baloise.github.io)
