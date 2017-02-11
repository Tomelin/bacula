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
  
          $bacula_dir_package = $::bacula::params::bacula_dir_package,
          $bacula_sd_package = $::bacula::params::bacula_sd_package,
          $bacula_fd_package = $::bacula::params::bacula_fd_package,
          $bacula_fd_service = $::bacula::params::bacula_fd_service,
          $bconsole_package = $::bacula::params::bconsole_package,
          $dirconf = $::bacula::params::dirconf,
          $fdport  = $::bacula::params::fdport,
          $workingDirectory = $::bacula::params::workingDirectory,
          $pidDirectory = $::bacula::params::pidDirectory,
          $maximumConcurrentJobs = $::bacula::params::maximumConcurrentJobs,
          
) inherits bacula::params {


}
