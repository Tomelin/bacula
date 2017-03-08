class bacula::client (
  # Conf default
  $dirconf               = "/etc/bacula",
  $piddirectory          = "/var/run/bacula",
  $maximumconcurrentjobs = '30',
  $dirconfclients        = "${dirconf}/clients",
  $dirbaculatmp          = "/tmp/bacula",
  $portftp               = $::bacula::portftp,
  # Bacula client - bacula-fd.conf
  $fdport                = "9102",
  $password_fd           = "${::passwordclient}",
  $bacula_fd_package     = $::bacula::bacula_fd_package,
  $bacula_fd_service     = $::bacula::bacula_fd_service,
  $dirserver             = $::bacula::dirserver,
  $workingdirectory      = $::bacula::workingdirectory,
  $filesbackup           = ["/"],
  $excludebackup         = ["/dev", "/proc", "/tmp","/.journal","/.fsck","/var/spool/bacula","/var/lib/bacula"],
  
  $signature             = $::bacula::params::signature,
  $compression           = $::bacula::params::compression,) {
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

  file { "$dirbaculatmp/client_${::hostname}.conf":
    ensure  => 'file',
    owner   => 'bacula',
    group   => 'bacula',
    content => template('bacula/director/client_conf.erb'),
    require => File["$dirbaculatmp"],
  }

  file { "$dirbaculatmp/baculaSendConfClient.sh":
    ensure  => 'file',
    owner   => 'bacula',
    group   => 'bacula',
    mode    => '0755',
    content => template('bacula/scripts/baculaSendConfClient.sh.erb'),
    require => File["$dirbaculatmp"],
    notify  => Exec['SendClientConf'],
  }

  exec { 'SendClientConf':
    path        => ['/usr/bin', '/usr/sbin'],
    command     => "$dirbaculatmp/baculaSendConfClient.sh",
    refreshonly => true,
    require     => Package["ftp"],
  }

}
