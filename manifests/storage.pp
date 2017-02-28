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
  $dirconf               = $::bacula::dirconf,
  $dirBaculaTMP          = $::bacula::dirBaculaTMP,
  $db_id                 = $::bacula::db_id,) {


#Package bacula-sd
  package { $bacula_sd_package:
    ensure => 'present',
  }

#workdir
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

#File temporary para enviar via ftp para o server 
  file { "$dirBaculaTMP":
    ensure => 'directory',
    owner  => 'bacula',
    group  => 'bacula',
  }
  
    file { "$dirBaculaTMP/${::hostname}.conf":
    ensure  => 'file',
    owner   => 'bacula',
    group   => 'bacula',
    content => template('bacula/director/storage_conf.erb'),
    require => File["$dirBaculaTMP"],
  }

  file { "$dirBaculaTMP/baculaSendConf.sh":
    ensure  => 'file',
    owner   => 'bacula',
    group   => 'bacula',
    mode    => '0755',
    content => template('bacula/scripts/baculaSendConf.sh.erb'),
    require => File["$dirBaculaTMP"],
    notify  => Exec['SendClientConf'],
  }
  
    package { 'ftp':
    ensure => 'present',
  }
  
  exec { 'SendConf':
    path        => ['/usr/bin', '/usr/sbin'],
    command     => "$dirBaculaTMP/baculaSendConf.sh",
    refreshonly => true,
    require => Package['ftp'],
  }

}
