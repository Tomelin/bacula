class bacula::director ($db_type = $::bacula::params::db_type,) {
  if "$db_type" == "mysql" {
    $db_id = 1
  }

  package { $::bacula::bacula_dir_package:
    ensure => 'present',
    before => Package['bacula-console'],
    notify => Exec['SetDBType'],
  }

  
  exec { 'SetDBType':
    path        => ['/usr/bin', '/usr/sbin'],
    command     => "alternatives --config libbaccats.so <<< $db_id",
    refreshonly => true,
  }
  


  # Install package
  package { 'bacula-console': ensure => 'present', }

  # start server
  service { $::bacula::bacula_dir_service:
    ensure     => 'running',
    enable     => true,
    hasrestart => true,
    hasstatus  => true,
    require    => Package[$::bacula::params::bacula_dir_package],
  }

  # Create file bacula-dir.conf
  file { "$::bacula::dirconf/bacula-dir.conf":
    ensure  => 'file',
    owner   => 'bacula',
    group   => 'bacula',
    content => template('bacula/bacula-dir.conf.erb'),
  }

  # Create file bconsole.conf
  file { "$::bacula::dirconf/bconsole.conf":
    ensure  => 'file',
    owner   => 'bacula',
    group   => 'bacula',
    content => template('bacula/bconsole.conf.erb'),
  }

  # Create directory  /bacula to save backup in file
  file { "$::bacula::dirBackupFile":
    ensure  => 'directory',
    recurse => true,
    owner   => 'bacula',
    group   => 'bacula',
  }

  # Create directory /etc/bacula/clients to save client conf
  file { "$::bacula::dirconf/clients":
    ensure  => 'directory',
    recurse => true,
    owner   => 'bacula',
    group   => 'bacula',
  }

  file { "$::bacula::dirconf/clients/client_bacula-dir.conf":
    ensure  => 'file',
    recurse => true,
    owner   => 'bacula',
    group   => 'bacula',
    content => template('bacula/director/client_bacula-dir.conf.erb'),
  }

  # Create directory /etc/bacula/jobs to save jobs conf
  file { "$::bacula::dirconf/jobs":
    ensure  => 'directory',
    recurse => true,
    owner   => 'bacula',
    group   => 'bacula',
  }

  file { "$::bacula::dirconf/jobs/job_bacula-dir.conf":
    ensure  => 'file',
    recurse => true,
    owner   => 'bacula',
    group   => 'bacula',
    content => template('bacula/director/job_bacula-dir.conf.erb'),
  }

  # Create directory /etc/bacula/pool to save pool conf
  file { "$::bacula::dirconf/pool":
    ensure  => 'directory',
    recurse => true,
    owner   => 'bacula',
    group   => 'bacula',
  }

  file { "$::bacula::dirconf/pool/pool_bacula-dir.conf":
    ensure  => 'file',
    recurse => true,
    owner   => 'bacula',
    group   => 'bacula',
    content => template('bacula/director/pool_bacula-dir.conf.erb'),
  }

  # Create directory  /bacula to save backup in file
  if $::bacula::typebackup == 'file' {
    file { "$::bacula::dirBackupFile/backup":
      ensure  => 'directory',
      recurse => true,
      owner   => 'bacula',
      group   => 'bacula',
    }

    file { "$::bacula::dirBackupFile/restore":
      ensure  => 'directory',
      recurse => true,
      owner   => 'bacula',
      group   => 'bacula',
    }
  }

}
