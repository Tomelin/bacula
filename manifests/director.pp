class bacula::director {
  package { $::bacula::bacula_dir_package: ensure => 'present' }




  service { $::bacula::bacula_dir_service:
    ensure     => 'running',
    enable     => true,
    hasrestart => true,
    hasstatus  => true,
    require    => Package[$::bacula::params::bacula_dir_package],
  }

  file { "$::bacula::dirconf/baculadir.conf":
    ensure  => 'file',
    owner   => 'bacula',
    group   => 'bacula',
    content => template('bacula/bacula-dir.conf.erb'),
  }
  
    file { "$::bacula::dirBackupFile":
    ensure  => 'directory',
    recurse => true,
    owner   => 'bacula',
    group   => 'bacula',
    
  }
  
  if $::bacula::typebackup == 'file'{
  file { "$::bacula::dirBackupFile/backup":
    ensure  => 'directory',
    recurse => true,
    owner   => 'bacula',
    group   => 'bacula',
    
  }
}

}
