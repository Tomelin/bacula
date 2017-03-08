# Class define variables the module bacula-fd - bacula client
# You should feel free to expand on this and document any parameters etc
class bacula::client (
  # Conf default
  $dirconf                 = '/etc/bacula',
  $pid_directory           = '/var/run/bacula',
  $maximum_concurrent_jobs = '30',
  $dir_conf_clients        = '${dirconf}/clients',
  $dir_bacula_tmp          = '/tmp/bacula',
  $port_ftp                = $::bacula::port_ftp,
  # Bacula client - bacula-fd.conf
  $fdport                  = '9102',
  $password_fd             = "${::passwordclient}",
  $bacula_fd_package       = $::bacula::bacula_fd_package,
  $bacula_fd_service       = $::bacula::bacula_fd_service,
  $dirserver               = $::bacula::dirserver,
  $working_directory       = $::bacula::working_directory,
  $filesBackup             = ['/'],
  $excludeBackup           = ['/dev', '/proc', '/tmp', '/.journal', '/.fsck', '/var/spool/bacula', '/var/lib/bacula'],
  $signature               = $::bacula::params::signature,
  $compression             = $::bacula::params::compression,) {
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

  file { "$dir_bacula_tmp/client_${::hostname}.conf":
    ensure  => 'file',
    owner   => 'bacula',
    group   => 'bacula',
    content => template('bacula/director/client_conf.erb'),
    require => File["$dir_bacula_tmp"],
  }

  file { "$dir_bacula_tmp/baculaSendConfClient.sh":
    ensure  => 'file',
    owner   => 'bacula',
    group   => 'bacula',
    mode    => '0755',
    content => template('bacula/scripts/baculaSendConfClient.sh.erb'),
    require => File["$dir_bacula_tmp"],
    notify  => Exec['SendClientConf'],
  }

  exec { 'SendClientConf':
    path        => ['/usr/bin', '/usr/sbin'],
    command     => "$dir_bacula_tmp/baculaSendConfClient.sh",
    refreshonly => true,
    require     => Package['ftp'],
  }

}
