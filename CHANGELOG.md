

# 2.0.0

If you are managing the installer with this module (`manage_installer => true`) then this release is not compatible with the 1.x releases, please read the release notes and documentation carefully.

* (break) Removed `source_path` option and replaced with `source_uri`
* (break) The module no longer supports downloading from `puppet:///` locations, if you really need to do this then you will need to manage the file from outside of this module (eg: your profile) and specify `manage_installer => false`.  The module supports `http://`, `https://`, `ftp://`, `file://` and `s3://` uri's as supported by puppet-archive
* Now uses `puppet/archive` instead of file resources for managing the installer 
* Added systemd unit file for managing the smo service on systemd based platforms
* New options for managing service
* Module now cleans up the installer file after install
* Various ordering/dependency bug fixes