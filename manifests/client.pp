class bacula::client (
  # Conf default
  $dirconf               = "/etc/bacula",
  $pidDirectory          = "/var/run/bacula",
  $maximumConcurrentJobs = '30',
  $dirConfClients        = "${dirconf}/clients",
  $dirBaculaTMP          = "/tmp/bacula",
  $portFTP               = '2121',
  # Bacula client - bacula-fd.conf
  $fdport                = "9102",
  $password_fd           = "${::passwordclient}",
  $bacula_fd_package     = $::bacula::bacula_fd_package,
  $bacula_fd_service     = $::bacula::bacula_fd_service,
  $dirserver            = $::bacula::dirserver,
  $workingDirectory      = $::bacula::workingDirectory,) {
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
    mode    => '0755',
    content => template('bacula/scripts/baculaSendConfClient.sh.erb'),
    require => File["$bacula::params::dirBaculaTMP"],
    notify  => Exec['SendClientConf'],
  }

notify {"$bacula::params::dirBaculaTMP": }
notify {"bacula::params::dirBaculaTMP": }


  exec { 'SendClientConf':
    path        => ['/usr/bin', '/usr/sbin'],
    command     => "$dirBaculaTMP/baculaSendConfClient.sh",
    refreshonly => true,
    require     => Package["$bacula::params::ftp"],
  }

}
