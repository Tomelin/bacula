#Configure client bacula
class bacula::client (

  Boolean $fd_manage                  = $::bacula::params::fd_manage,
  String  $fd_version                 = $::bacula::params::fd_version,
  String  $fd_package                 = $::bacula::params::fd_package,
  String  $fd_service                 = $::bacula::params::fd_service,
  String  $fd_dir_config              = $::bacula::params::fd_dir_config,
  String  $fd_file_config             = $::bacula::params::fd_file_config,
  String  $fd_name                    = $::bacula::params::fd_name,
  Integer $fd_port                    = $::bacula::params::fd_port,
  Optional[String]  $fd_address       = undef, #$::bacula::params::fd_address,
  String  $fd_working_directory       = $::bacula::params::fd_working_directory,
  String  $fd_pid_directory           = $::bacula::params::fd_pid_directory,
  Integer $fd_maximum_concurrent_jobs = $::bacula::params::fd_maximum_concurrent_jobs,
  String  $fd_password                = $::bacula::params::fd_password,
  String  $fd_server                  = $::bacula::params::fd_server,
  String  $fd_mon_name                = $::bacula::params::fd_mon_name,
  String  $fd_mon_password            = $::bacula::params::fd_mon_password,
  Boolean $fd_mon                     = $::bacula::params::fd_mon,
  String  $fd_messages_name           = $::bacula::params::fd_messages_name,
  String  $fd_messages_director       = $::bacula::params::fd_messages_director,
  Boolean $fd_auto_prune              = $::bacula::params::fd_auto_prune,
  String  $fd_file_retention          = $::bacula::params::fd_file_retention,
  String  $fd_job_retention           = $::bacula::params::fd_job_retention,
  String  $fd_tag                     = $::bacula::params::fd_tag,

  #Fileset
  String  $fd_fileset_name            = "${facts['networking']['hostname']}_fileset",
  Array   $fd_fileset_include         = ['/etc','/usr/local','/var'],
  Hash    $fd_fileset_include_options = {'Onefs'      => 'no',
                                        'Compression' => 'GZIP',
                                        'signature'   => 'MD5'},
  Array   $fd_fileset_exclude         = ['/var/log','/var/run','/var/tmp'],
  Optional[Hash]    $fd_fileset_exclude_options = undef,

  #job
  String  $fd_job_name            = "${facts['networking']['hostname']}_job",
  String  $fd_job_fileset         = $fd_fileset_name,
  String  $fd_job_defs            = 'DefaultJob',
  String  $fd_job_type            = 'Backup',
  Optional[String]  $fd_job_pool            = undef,

  ) inherits ::bacula::params{

  package { $fd_package: ensure => 'present' }

  file { 'fd_working_directory':
    ensure  => 'directory',
    name    => $fd_working_directory,
    owner   => 'bacula',
    group   => 'bacula',
    require => Package[$fd_package],
  }

  file { 'fd_pid_directory':
    ensure  => 'directory',
    name    => $fd_pid_directory,
    owner   => 'bacula',
    group   => 'bacula',
    require => Package[$fd_package],
  }

  file { "${fd_dir_config}/${fd_file_config}":
    ensure  => 'file',
    owner   => 'bacula',
    group   => 'bacula',
    content => epp('bacula/bacula-fd.conf'),
    require => Package[$fd_package],
    notify  => Service[$fd_service],
  }

  service { $fd_service:
    ensure     => 'running',
    enable     => true,
    hasrestart => true,
    hasstatus  => true,
    }

    if $fd_manage == true {
      class { '::bacula::client::resource':
        fd_name           => $fd_name,
        fd_address        => $fd_address,
        fd_port           => $fd_port,
        fd_password       => $fd_password,
        fd_file_retention => $fd_file_retention,
        fd_job_retention  => $fd_job_retention,
        fd_auto_prune     => $fd_auto_prune,
        fd_dir_config     => $fd_dir_config,
        fd_tag            => $fd_tag,

        fd_fileset_name            => $fd_fileset_name,
        fd_fileset_include         => $fd_fileset_include,
        fd_fileset_include_options => $fd_fileset_include_options,
        fd_fileset_exclude         => $fd_fileset_exclude,
        fd_fileset_exclude_options => $fd_fileset_exclude_options,

        fd_job_name    => $fd_job_name,
        fd_job_fileset => $fd_job_fileset,
        fd_job_defs    => $fd_job_defs,
        fd_job_type    => $fd_job_type,
        fd_job_pool    => $fd_job_pool,
      }
    }
}
