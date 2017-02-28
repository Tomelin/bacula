class bacula::storage (
  $db_type               = $::bacula::params::db_type,
  $bacula_sd_package    = $::bacula::bacula_sd_package,
  $bacula_sd_service    = $::bacula::bacula_sd_service,
  $sdconf               = $::bacula::dirconf,
  $sdport               = $::bacula::dirport,
  $workingDirectory      = $::bacula::workingDirectory,
  $pidDirectory          = $::bacula::pidDirectory,
  $maximumConcurrentJobs = $::bacula::maximumConcurrentJobs,
  $db_package            = $::bacula::db_package,
  $bacula_dir            = $::bacula::bacula_dir,
  $db_id                 = $::bacula::db_id,) {


  package { $bacula_sd_package:
    ensure => 'present',
  }

  file { "$workingDirectory":
    ensure  => directory,
    recurse => true,
    owner   => 'bacula',
    group   => 'bacula',
  }
  
      file { "$pidDirectory":
    ensure  => directory,
    recurse => true,
    owner   => 'bacula',
    group   => 'bacula',
  }

 
  # start server
  service { $bacula_sd_service:
    ensure     => 'running',
    enable     => true,
    hasrestart => true,
    hasstatus  => true,
    require    => Package[$bacula_sd_package],
  }

  # Create file bacula-sd.conf
  file { "$dirconf/bacula-sd.conf":
    ensure  => 'file',
    owner   => 'bacula',
    group   => 'bacula',
    content => template('bacula/bacula-sd.conf.erb'),
    require => Package[$bacula_sd_package],
    notify => Service[$bacula_sd_service],
  }

}
