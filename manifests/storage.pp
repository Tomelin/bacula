class bacula::storage (
  $db_type               = $::bacula::params::db_type,
  $bacula_sd_package     = $::bacula::bacula_sd_package,
  $bacula_sd_service     = $::bacula::bacula_sd_service,
  $sdconf                = $::bacula::dirconf,
  $sdport                = $::bacula::sdport,
  $workingdirectory      = $::bacula::workingdirectory,
  $piddirectory          = $::bacula::piddirectory,
  $maximumconcurrentjobs = $::bacula::maximumconcurrentjobs,
  $db_package            = $::bacula::db_package,
  $dirserver             = $::bacula::dirserver,
  $dirconf               = $::bacula::dirconf,
  $dirbaculatmp          = $::bacula::dirbaculatmp,
  $db_id                 = $::bacula::db_id,
  $dirbackupfile         = $::bacula::dirbackupfile,
  $dirrestorefile        = $::bacula::dirrestorefile,) {
  # Package bacula-sd
  package { $bacula_sd_package: ensure => 'present', }

  
    # Create directory  /bacula to save backup in file
  if $::bacula::typebackup == 'file' {
    file { "$::bacula::dirbackupfile/backup":
      ensure  => 'directory',
      recurse => true,
      owner   => 'bacula',
      group   => 'bacula',
    }
  }
    file { "${dirbackupfile}/restore":
      ensure  => 'directory',
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
    notify  => Service[$bacula_sd_service],
  }

  file { "$dirbaculatmp/${::hostname}.conf":
    ensure  => 'file',
    owner   => 'bacula',
    group   => 'bacula',
    content => template('bacula/director/storage_conf.erb'),
    require => File["$dirbaculatmp"],
  }

  file { "$dirbaculatmp/baculaSendConf.sh":
    ensure  => 'file',
    owner   => 'bacula',
    group   => 'bacula',
    mode    => '0755',
    content => template('bacula/scripts/baculaSendConf.sh.erb'),
    require => File["$dirbaculatmp"],
    notify  => Exec['SendClientConf'],
  }

  exec { 'SendConf':
    path        => ['/usr/bin', '/usr/sbin'],
    command     => "$dirbaculatmp/baculaSendConf.sh",
    refreshonly => true,
    require     => Package['ftp'],
  }

}
