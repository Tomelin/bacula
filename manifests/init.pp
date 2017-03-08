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
  $bacula_sd_service     = $::bacula::params::bacula_sd_service,
  $bconsole_package      = $::bacula::params::bconsole_package,
  $dirconf               = $::bacula::params::dirconf,
  $fdport                = $::bacula::params::fdport,
  $sdport                = $::bacula::params::sdport,
  $workingDirectory      = $::bacula::params::workingDirectory,
  $pidDirectory          = $::bacula::params::pidDirectory,
  $maximumConcurrentJobs = $::bacula::params::maximumConcurrentJobs,
  $typebackup            = $::bacula::params::typebackup,
  $dirBackupFile         = $::bacula::params::dirBackupFile,
  $dirRestoreFile        = $::bacula::params::dirRestoreFile,
  $is_client             = $::bacula::params::is_client,
  $is_storage            = $::bacula::params::is_storage,
  $is_director           = $::bacula::params::is_director,
  $is_console            = $::bacula::params::is_console,
  $password_fd           = $::bacula::params::password_fd,
  $dirserver             = $::bacula::params::dirserver,
  $dirBaculaTMP          = $::bacula::params::dirBaculaTMP,
  $dirConfClients        = $::bacula::params::dirConfClients,
  $dirConfStorage        = $::bacula::params::dirConfStorage,
  $portFTP               = $::bacula::params::portFTP,
  $is_directorFTP        = $::bacula::params::is_directorFTP,
  $dirport               = $::bacula::params::dirport,
  $db_package            = $::bacula::params::db_package,
  $db_id                 = $::bacula::params::db_id,
  $heartbeatInterval     = $::bacula::params::heartbeatInterval,
  $signature             = $::bacula::params::signature,
  $firewall              = $::bacula::params::firewall,
  
  ) inherits bacula::params {
  if $is_director == true {
    class { 'bacula::director': }

    if $firewall == true {
      
      class { 'bacula::firewall': }
      firewalld_service { 'Open port bacula server in the public zone':
        ensure  => present,
        zone    => 'public',
        service => 'bacula-server',
      }
    }

    if $is_directorFTP == true {
      class { 'bacula::proftpd': }

      class { 'bacula::firewall': }
      if $firewall == true {
        firewalld_port { 'Open port FTP is a protocol used for remote file transfer':
          ensure   => present,
          zone     => 'public',
          port     => "$portFTP",
          protocol => 'tcp',
        }
      }
    }
  }

  if $is_storage == true {
    class { 'bacula::storage': }

    if ($firewall == true) and ($is_director == false) {
      firewalld_service { 'Open port bacula server in the public zone':
        ensure  => present,
        zone    => 'public',
        service => 'bacula-server',
      }
    }
  }

  if $is_client == true {
    class { 'bacula::client': }

    if $firewall == true {
      firewalld_service { 'Open port bacula client in the public zone':
        ensure  => present,
        zone    => 'public',
        service => 'bacula-client',
      }

    }

  }

}

