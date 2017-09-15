# SD bacula - bacula-sd.conf
class bacula::storage (

  Boolean $sd_manage									 = $::bacula::params::sd_manage,
  String  $sd_version								   = $::bacula::params::sd_version,
  String  $sd_dir_config               = $::bacula::params::sd_dir_config,
  String  $sd_file_config              = $::bacula::params::sd_file_config,
  String  $sd_name                     = $::bacula::params::sd_name,
  Integer $sd_port                     = $::bacula::params::sd_port,
  Optional[Array[String]] $sd_address  = [$::bacula::params::sd_address],
  String  $sd_working_directory        = $::bacula::params::sd_working_directory,
  String  $sd_pid_directory            = $::bacula::params::sd_pid_directory,
  Integer $sd_maximum_concurrent_jobs  = $::bacula::params::sd_maximum_concurrent_jobs,
  String  $sd_password                 = $::bacula::params::sd_password,
  String  $sd_server                   = $::bacula::params::sd_server,
  String  $sd_mon_name                 = $::bacula::params::sd_mon_name,
  String  $sd_mon_password             = $::bacula::params::sd_mon_password,
  Boolean $sd_mon                      = $::bacula::params::sd_mon,
  String  $sd_messages_name            = $::bacula::params::sd_messages_director,
  String  $sd_messages_director        = $::bacula::params::sd_messages_director,
  Enum['yes','no'] $sd_auto_prune      = $::bacula::params::sd_auto_prune,
  String  $sd_file_retention           = $::bacula::params::sd_file_retention,
  String  $sd_job_retention            = $::bacula::params::sd_job_retention,
  String  $sd_tag                      = $::bacula::params::sd_tag,
  Enum['mysql','postgresql','sqlite'] $sd_db_type = $::bacula::params::sd_db_type,

  ) inherits ::bacula::params{

  package { $sd_package:
    ensure => 'present',
  }

  file { 'sd_working_directory':
    ensure  => 'directory',
    name    => $sd_working_directory,
    owner   => 'bacula',
    group   => 'bacula',
    require => Package[$sd_package],
  }

  file { 'sd_pid_directory':
    ensure  => 'directory',
    name    => $sd_pid_directory,
    owner   => 'bacula',
    group   => 'bacula',
    require => Package[$sd_package],
  }

  service { $sd_service:
    ensure     => 'running',
    enable     => true,
    hasrestart => true,
    hasstatus  => true,
  }

  concat{ '/etc/bacula/bacula-sd.conf': }

  concat::fragment { $sd_service:
    target  => '/etc/bacula/bacula-sd.conf',
    content => epp('bacula/bacula-sd.conf'),
    order => '01',
    require => Package[$sd_package],
  }

  if $sd_manage == true {
    class { '::bacula::storage::storage':
      sd_name           => $sd_name,
      sd_address        => $sd_address,
      sd_port           => $sd_port,
      sd_password       => $sd_password,
      sd_dir_config     => $sd_dir_config,
      sd_tag            => $sd_tag,
    }
  }
}
