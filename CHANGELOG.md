### 2.1.1

* Fixed bug with service stopping and starting on every Puppet run with upgradable https://github.com/crayfishx/puppet-netapp_smo/pull/7
* Fixed netapp-smo service not being enabled https://github.com/crayfishx/puppet-netapp_smo/pull/6
* Fixed scoping of service_name attribute and other minor lint fixes


## 2.1.0

Feature release.

* Added the `upgradable` attribute to enable the module to track installed versions and attempt to upgrade an SMO installation.  By default this behaviour is disabled and can be enabled by setting `upgradable` to `true`.  See the README for more information on this option.


### 2.0.1

Minor forge release, corrects the use of "SnapDrive for Oracle" to "SnapManager for Oracle"

* systemd template service description changed to reflect "SnapManager for Oracle"



# 2.0.0

If you are managing the installer with this module (`manage_installer => true`) then this release is not compatible with the 1.x releases, please read the release notes and documentation carefully.

* (break) Removed `source_path` option and replaced with `source_uri`
* (break) The module no longer supports downloading from `puppet:///` locations, if you really need to do this then you will need to manage the file from outside of this module (eg: your profile) and specify `manage_installer => false`.  The module supports `http://`, `https://`, `ftp://`, `file://` and `s3://` uri's as supported by puppet-archive
* Now uses `puppet/archive` instead of file resources for managing the installer 
* Added systemd unit file for managing the smo service on systemd based platforms
* New options for managing service
* Module now cleans up the installer file after install
* Various ordering/dependency bug fixes
