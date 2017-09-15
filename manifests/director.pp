class bacula::director (
  Boolean $dir_manage									  = $::bacula::params::dir_manage,
  String  $dir_version								  = $::bacula::params::dir_version,
  String  $dir_dir_config               = $::bacula::params::dir_dir_config,
  String  $dir_service                   = $::bacula::params::dir_service,
  String  $dir_package                   = $::bacula::params::dir_package,
  String  $dir_file_config              = $::bacula::params::dir_file_config,
  String  $dir_name                     = $::bacula::params::dir_name,
  Integer $dir_port                     = $::bacula::params::dir_port,
  Optional[Array[String]] $dir_address  = [$::bacula::params::dir_address],
  String  $dir_working_directory        = $::bacula::params::dir_working_directory,
  String  $dir_pid_directory            = $::bacula::params::dir_pid_directory,
  Integer $dir_maximum_concurrent_jobs  = $::bacula::params::dir_maximum_concurrent_jobs,
  String  $dir_password                 = $::bacula::params::dir_password,
  String  $dir_server                   = $::bacula::params::dir_server,
  Enum['mysql','postgresql','sqlite'] $dir_db_type = $::bacula::params::dir_db_type,
  ) {

  bacula::director::db { $dir_db_type: }

  package { $dir_package:
    ensure => 'present',
    notify => Exec['SetDBType'],
  }

  file { 'dir_working_directory':
    ensure  => directory,
    name    => $dir_working_directory,
    recurse => true,
    owner   => 'bacula',
    group   => 'bacula',
  }

    file { 'dir_pid_directory':
    ensure  => directory,
    name    => $dir_pid_directory,
    recurse => true,
    owner   => 'bacula',
    group   => 'bacula',
  }

  # Create file bacula-dir.conf
  file { "${dir_dir_config}/${dir_file_config}":
    ensure  => 'file',
    owner   => 'bacula',
    group   => 'bacula',
    content => template('bacula/bacula-dir.conf.erb'),
  }

  # Create directory /etc/bacula/clients to save client conf
  file { "${dir_dir_config}/conf.d":
    ensure  => 'directory',
    recurse => true,
    owner   => 'bacula',
    group   => 'bacula',
    mode    => '0777',
    require => Package[$dir_package],
  }

  # start server
  service { $dir_service:
    ensure     => 'running',
    enable     => true,
    hasrestart => true,
    hasstatus  => true,
    require    => Package[$dir_package],
  }

  # Create directory  /bacula to save backup in file
  file { "$::bacula::dirBackupFile":
    ensure  => 'directory',
    recurse => true,
    owner   => 'bacula',
    group   => 'bacula',
    require => Package[$dir_package],
  }



  # Create directory /etc/bacula/pool to save pool conf
  file { "$dirconf/pool":
    ensure  => 'directory',
    recurse => true,
    owner   => 'bacula',
    group   => 'bacula',
    require => Package[$dir_package],
  }

  file { "$dirconf/pool/pool_bacula-dir.conf":
    ensure  => 'file',
    recurse => true,
    owner   => 'bacula',
    group   => 'bacula',
    content => template('bacula/director/pool_bacula-dir.conf.erb'),
    require => File["$dirconf/pool"],
  }

  #Create in storage
  # Create directory  /bacula to save backup in file
  if $::bacula::typebackup == 'file' {
    file { "$::bacula::dirBackupFile/backup":
      ensure  => 'directory',
      recurse => true,
      owner   => 'bacula',
      group   => 'bacula',
    }

    file { "$::bacula::dirBackupFile/restore":
      ensure  => 'directory',
      recurse => true,
      owner   => 'bacula',
      group   => 'bacula',
    }
  }

  class { 'bacula::director::pool':
  }


  exec { 'SetDBType':
    path        => ['/usr/bin', '/usr/sbin'],
    command     => "alternatives --config libbaccats.so <<< $db_id",
    refreshonly => true,
    notify      => Service[$dir_service],
  }

 Package[$dir_package] ->
 File['dir_working_directory'] ->
 File['dir_pid_directory'] ->
 File["${dir_dir_config}/conf.d"] ->
 File["${dir_dir_config}/${dir_file_config}"] ~>
 Service[$dir_service]

}
