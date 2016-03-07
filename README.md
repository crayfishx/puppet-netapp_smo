# netapp_smo


## Introduction 

This module manages the SnapManager for Oracle package.

## Packaging

The SMO package comes as a binary self-contained executable installer that supports a silent running mode.  The .bin file must already exist, or be downloaded from the Puppet server from a specified source.

## Example

```
    class { 'netapp_smo':
      version     => '3.4',
      source_path => 'puppet:///binaries/smo',
    }
```

## Parameters

`source_path`
Path to find the installation binary (eg: puppet:///modules/smo)

`version`
Version of SMO to install

`manage_installer`
True or false, whether to manage the installer binary, if set to false then the binary must exist on the system

`installer_path`
Path where the installer binary is to be found, if manage_installer is set to true then the module will create this folder and download the binary to it

`system_type`
The system type we are installing, default: linux

`system_arch`
The system arch we are installing, default: x64

`installer_filename`
If version, arch and system_type are set then the installer filename will be determined automatically, but can be overridden here.  

## Author

* Written and maintained by Craig Dunn <craig@craigdunn.org> @crayfisx
* Sponsered by Baloise Group [http://baloise.github.io](http://baloise.github.io)
