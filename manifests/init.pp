# == Class: bacula
#
# Full description of class bacula here.
#
# === Parameters
#
# Document parameters here.
#
# [*sample_parameter*]
#   Explanation of what this parameter affects and what it defaults to.
#   e.g. "Specify one or more upstream ntp servers as an array."
#
# === Variables
#
# Here you should define a list of variables that this module would require.
#
# [*sample_variable*]
#   Explanation of how this variable affects the funtion of this class and if
#   it has a default. e.g. "The parameter enc_ntp_servers must be set by the
#   External Node Classifier as a comma separated list of hostnames." (Note,
#   global variables should be avoided in favor of class parameters as
#   of Puppet 2.6.)
#
# === Examples
#
#  class { bacula:
#    servers => [ 'pool.ntp.org', 'ntp.local.company.com' ],
#  }
#
# === Authors
#
# Author Name <author@domain.com>
#
# === Copyright
#
# Copyright 2017 Your name here, unless otherwise noted.
#
class bacula (
  $bacula_dir_package    = $::bacula::params::bacula_dir_package,
  $bacula_dir_service    = $::bacula::params::bacula_dir_service,
  $bacula_sd_package     = $::bacula::params::bacula_sd_package,
  $bacula_fd_package     = $::bacula::params::bacula_fd_package,
  $bacula_fd_service     = $::bacula::params::bacula_fd_service,
  $bconsole_package      = $::bacula::params::bconsole_package,
  $dirconf               = $::bacula::params::dirconf,
  $fdport                = $::bacula::params::fdport,
  $sdport                = $::bacula::params::sdport,
  $workingDirectory      = $::bacula::params::workingDirectory,
  $pidDirectory          = $::bacula::params::pidDirectory,
  $maximumConcurrentJobs = $::bacula::params::maximumConcurrentJobs,
  $typebackup            = $::bacula::params::typebackup,
  $dirBackupFile         = $::bacula::params::dirBackupFile,
  $is_client             = $::bacula::params::is_client,
  $is_storage            = $::bacula::params::is_storage,
  $is_director           = $::bacula::params::is_director,
  $is_console            = $::bacula::params::is_console,
  $password_fd           = $::bacula::params::password_fd,
  $bacula_dir            = $::bacula::params::bacula_dir,
  $ftp_package           = $::bacula::params::ftp_package,
  $dirBaculaTMP     = $::bacula::params::dirBaculaTMP,
  
  ) inherits bacula::params {

  if $is_director == true {
    class { 'bacula::director': }

    if $is_directorFTP == true {
      class { 'bacula::proftpd': }
    }
  }
  
     
  if $is_client == true {
    class { 'bacula::client': }
  }


}

