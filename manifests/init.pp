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
  $bacula_dir_package      = $::bacula::params::bacula_dir_package,
  $bacula_dir_service      = $::bacula::params::bacula_dir_service,
  $bacula_sd_package       = $::bacula::params::bacula_sd_package,
  $bacula_fd_package       = $::bacula::params::bacula_fd_package,
  $bacula_fd_service       = $::bacula::params::bacula_fd_service,
  $bacula_sd_service       = $::bacula::params::bacula_sd_service,
  $bconsole_package        = $::bacula::params::bconsole_package,
  $dirconf                 = $::bacula::params::dirconf,
  $fdport                  = $::bacula::params::fdport,
  $sdport                  = $::bacula::params::sdport,
  $working_directory       = $::bacula::params::working_directory,
  $pid_directory           = $::bacula::params::pid_directory,
  $maximum_concurrent_jobs = $::bacula::params::maximum_concurrent_jobs,
  $typebackup              = $::bacula::params::typebackup,
  $dir_backup_file         = $::bacula::params::dir_backup_file,
  $dir_restore_file        = $::bacula::params::dir_restore_file,
  $is_client               = $::bacula::params::is_client,
  $is_storage              = $::bacula::params::is_storage,
  $is_director             = $::bacula::params::is_director,
  $is_console              = $::bacula::params::is_console,
  $password_fd             = $::bacula::params::password_fd,
  $dirserver               = $::bacula::params::dirserver,
  $dir_bacula_tmp          = $::bacula::params::dir_bacula_tmp,
  $dir_conf_clients        = $::bacula::params::dir_conf_clients,
  $dir_conf_storage        = $::bacula::params::dir_conf_storage,
  $port_ftp                = $::bacula::params::port_ftp,
  $is_director_ftp         = $::bacula::params::is_director_ftp,
  $dirport                 = $::bacula::params::dirport,
  $db_package              = $::bacula::params::db_package,
  $db_id                   = $::bacula::params::db_id,
  $heartbeat_interval      = $::bacula::params::heartbeat_interval,
  $signature               = $::bacula::params::signature,
  $firewall                = $::bacula::params::firewall,
  $compression             = $::bacula::params::compression,
  $emails                  = $::bacula::params::emails,) inherits bacula::params {
  if $is_client == true {
    class { 'bacula::client': }

  }

  if $is_director == true {
    class { 'bacula::director': }

    if $is_director_ftp == true {
      class { 'bacula::proftpd': }

    }
  }

  if $is_storage == true {
    class { 'bacula::storage': }

  }

  class { 'bacula::firewall':
  }

  class { 'bacula::selinux':
  }

}

