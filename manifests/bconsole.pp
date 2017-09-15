# bconsole bacula - bconsole.conf
class bacula::bconsole (

  Boolean $bconsole_manege      = $::bacula::params::bconsole_manege,
  String  $bconsole_package     = $::bacula::params::bconsole_package,
  String  $bconsole_name        = $::bacula::params::bconsole_name,
  Integer $bconsole_dir_port    = $::bacula::params::bconsole_dir_port,
  String  $bconsole_address     = $::bacula::params::bconsole_address,
  String  $bconsole_password    = $::bacula::params::bconsole_password,
  String  $bconsole_dir_config  = $::bacula::params::bconsole_dir_config,
  String  $bconsole_file_config = $::bacula::params::bconsole_file_config,

  ) inherits ::bacula::params {

  package { $bconsole_package: ensure => 'present' }

  file { "${bconsole_dir_config}/${bconsole_file_config}":
    ensure  => 'file',
    owner   => 'bacula',
    group   => 'bacula',
    content => epp('bacula/bconsole.conf'),
    require => Package[$bconsole_package],
  }
}
