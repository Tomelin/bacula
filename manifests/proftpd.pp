class bacula::proftpd (
  $serverName        = 'ProFTPD Anonymous Server',
  $serverType        = 'standalone',
  $portFTP           = $::bacula::params::portFTP,
  $user              = 'ftp',
  $group             = 'ftp',
  $maxInstances      = '30',
  $timeoutStalled    = '300',
  $displayLogin      = 'welcome.msg',
  $dirDisplayLogin   = "/var/ftp/$::displayLogin",
  $displayFirstChdir = '.message',
  $dirFTP            = '/etc/bacula/clients',
  $loginFTP          = 'AllowAll',
  $maxClients        = 5,
  $dirConfClients    = $::bacula::params::dirConfClients,
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

  #file { "${dirDisplayLogin}":
  file { "/var/ftp/welcome.msg":
    ensure  => 'file',
    owner   => 'ftp',
    group   => 'ftp',
    content => template('bacula/proftpd/message.erb'),
    require => Package[$package_name],
  }

}