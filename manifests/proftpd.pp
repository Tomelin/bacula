# Class define variables the module ftp with proftpd - server ftp
# You should feel free to expand on this and document any parameters etc
class bacula::proftpd (
  $server_name        = 'ProFTPD Anonymous Server',
  $server_type        = 'standalone',
  $port_ftp           = $::bacula::port_ftp,
  $user              = 'ftp',
  $group             = 'ftp',
  $max_instances      = '30',
  $timeout_stalled    = '300',
  $display_login      = 'welcome.msg',
  $dir_display_login   = "/var/ftp/${display_login}",
  $display_first_chdir = '.message',
  $dir_ftp            = '/etc/bacula/clients',
  $login_ftp          = 'AllowAll',
  $max_clients        = 5,
  $dir_conf_clients    = $::bacula::dir_conf_clients,
  $dir_conf_storage    = $::bacula::dir_conf_storage,
  $package_name      = 'proftpd',
  $service_name      = 'proftpd',) {
  package { $package_name: ensure => 'installed' }

  service { $service_name:
    require   => Package[$package_name],
    enable    => true,
    ensure    => 'running',
    hasstatus => true,
  }

  file { "/etc/proftpd.conf":
    require => Package[$package_name],
    content => template('bacula/proftpd/proftpd.conf.erb'),
    notify  => Service[$service_name],
  }

  file { $dir_display_login:
    ensure  => 'file',
    owner   => 'ftp',
    group   => 'ftp',
    content => template('bacula/proftpd/message.erb'),
    require => Package[$package_name],
  }

}