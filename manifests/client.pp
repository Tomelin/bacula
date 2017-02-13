class bacula::client (
  $bacula_fd_package = $::bacula::bacula_fd_package,
  $bacula_fd_service = $::bacula::bacula_fd_service,
  $dirconf           = $::bacula::dirconf,
  $password_fd       = $::bacula::password_fd,
  $dirBaculaTMP     = $::bacula::dirBaculaTMP,) {
  package { $bacula_fd_package: ensure => 'present' }

  service { $bacula_fd_service:
    ensure     => 'running',
    enable     => true,
    hasrestart => true,
    hasstatus  => true,
    require    => Package[$bacula_fd_package],
  }

  file { "$dirconf/bacula-fd.conf":
    ensure  => 'file',
    owner   => 'bacula',
    group   => 'bacula',
    content => template('bacula/bacula-fd.conf.erb'),
    require => Package[$bacula_fd_package],
    notify  => Service[$bacula_fd_service]
  }

  file { "$dirBaculaTMP":
    ensure => 'directory',
    owner  => 'bacula',
    group  => 'bacula',
  }

  file { "$dirBaculaTMP/client_${::hostname}.conf":
    ensure  => 'file',
    owner   => 'bacula',
    group   => 'bacula',
    content => template('bacula/director/client_conf.erb'),
    require => File["$dirBaculaTMP"],
  }
  
    file { "$dirBaculaTMP/baculaSendConfClient.sh":
    ensure  => 'file',
    owner   => 'bacula',
    group   => 'bacula',
    mode => '0755',
    content => template('bacula/scripts/baculaSendConfClient.sh.erb'),
    require => File["$dirBaculaTMP"],
  }
  
  

  exec { 'SendClientConf':
    path        => ['/usr/bin', '/usr/sbin'],
    command     => 'teste',
    refreshonly => true,
    
  }

}
