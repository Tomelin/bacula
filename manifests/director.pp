class bacula::director {
  package { $::bacula::bacula_dir_package:
    ensure => 'present',
    before => Package['bacula-console']
  }

  package { 'bacula-console': ensure => 'present', }

  service { $::bacula::bacula_dir_service:
    ensure     => 'running',
    enable     => true,
    hasrestart => true,
    hasstatus  => true,
    require    => Package[$::bacula::params::bacula_dir_package],
  }

  file { "$::bacula::dirconf/bacula-dir.conf":
    ensure  => 'file',
    owner   => 'bacula',
    group   => 'bacula',
    content => template('bacula/bacula-dir.conf.erb'),
  }

  file { "$::bacula::dirconf/bconsole.conf":
    ensure  => 'file',
    owner   => 'bacula',
    group   => 'bacula',
    content => template('bacula/bconsole.conf.erb'),
  }

  file { "$::bacula::dirBackupFile":
    ensure  => 'directory',
    recurse => true,
    owner   => 'bacula',
    group   => 'bacula',
  }

  file { "$::bacula::dirconf/clients":
    ensure  => 'directory',
    recurse => true,
    owner   => 'bacula',
    group   => 'bacula',
  }

  file { "$::bacula::dirconf/jobs":
    ensure  => 'directory',
    recurse => true,
    owner   => 'bacula',
    group   => 'bacula',
  }

  file { "$::bacula::dirconf/pool":
    ensure  => 'directory',
    recurse => true,
    owner   => 'bacula',
    group   => 'bacula',
  }

  if $::bacula::typebackup == 'file' {
    file { "$::bacula::dirBackupFile/backup":
      ensure  => 'directory',
      recurse => true,
      owner   => 'bacula',
      group   => 'bacula',
    }
  }

}
