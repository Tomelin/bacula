class bacula::proftpd (
  $servername        = 'ProFTPD Anonymous Server',
  $servertype        = 'standalone',
  $portftp           = $::bacula::portftp,
  $user              = 'ftp',
  $group             = 'ftp',
  $maxinstances      = '30',
  $timeoutstalled    = '300',
  $displaylogin      = 'welcome.msg',
  $dirdisplaylogin   = "/var/ftp/${displaylogin}",
  $displayfirstchdir = '.message',
  $dirftp            = '/etc/bacula/clients',
  $loginftp          = 'AllowAll',
  $maxclients        = 5,
  $dirconfclients    = $::bacula::dirconfclients,
  $dirconfstorage    = $::bacula::dirconfstorage,
  $package_name      = 'proftpd',
  $service_name      = 'proftpd',) {
  package { $package_name: ensure => 'installed' }

  service { $service_name:
    require   => Package[$package_name],
    enable    => true,
    ensure    => running,
    hasstatus => true,
  }

  file { "/etc/proftpd.conf":
    require => Package[$package_name],
    content => template('bacula/proftpd/proftpd.conf.erb'),
    notify  => Service[$service_name],
  }

  file { "${dirdisplaylogin}":
    ensure  => 'file',
    owner   => 'ftp',
    group   => 'ftp',
    content => template('bacula/proftpd/message.erb'),
    require => Package[$package_name],
  }

}