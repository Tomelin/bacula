class bacula::storage (
  $db_type                 = $::bacula::params::db_type,
  $bacula_sd_package       = $::bacula::bacula_sd_package,
  $bacula_sd_service       = $::bacula::bacula_sd_service,
  $sdconf                  = $::bacula::dirconf,
  $sdport                  = $::bacula::sdport,
  $working_directory       = $::bacula::working_directory,
  $pid_directory           = $::bacula::pid_directory,
  $maximum_concurrent_jobs = $::bacula::maximum_concurrent_jobs,
  $db_package              = $::bacula::db_package,
  $dirserver               = $::bacula::dirserver,
  $dirconf                 = $::bacula::dirconf,
  $dir_bacula_tmp          = $::bacula::dir_bacula_tmp,
  $db_id                   = $::bacula::db_id,
  $dir_backup_file         = $::bacula::dir_backup_file,
  $dir_restore_file        = $::bacula::dir_restore_file,) {
  # Package bacula-sd
  package { $bacula_sd_package: ensure => 'present', }

  # Create directory  /bacula to save backup in file
  if $::bacula::typebackup == 'file' {
    file { $::bacula::dir_backup_file:
      ensure  => 'directory',
      recurse => true,
      force   => true,
      owner   => 'bacula',
      group   => 'bacula',
      require => File[$::bacula::dir_backup_default],
    }
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

  file { "$dir_bacula_tmp/${::hostname}.conf":
    ensure  => 'file',
    owner   => 'bacula',
    group   => 'bacula',
    content => template('bacula/director/storage_conf.erb'),
    require => File["$dir_bacula_tmp"],
  }

  file { "$dir_bacula_tmp/baculaSendConf.sh":
    ensure  => 'file',
    owner   => 'bacula',
    group   => 'bacula',
    mode    => '0755',
    content => template('bacula/scripts/baculaSendConf.sh.erb'),
    require => File["$dir_bacula_tmp"],
    notify  => Exec['SendClientConf'],
  }

  exec { 'SendConf':
    path        => ['/usr/bin', '/usr/sbin'],
    command     => "$dir_bacula_tmp/baculaSendConf.sh",
    refreshonly => true,
    require     => Package['ftp'],
  }

}
