class bacula::director (
  $db_type               = $::bacula::params::db_type,
  $bacula_dir_package    = $::bacula::bacula_dir_package,
  $bacula_dir_service    = $::bacula::bacula_dir_service,
  $dirconf               = $::bacula::dirconf,
  $dirport               = $::bacula::dirport,
  $workingDirectory      = $::bacula::workingDirectory,
  $pidDirectory          = $::bacula::pidDirectory,
  $maximumConcurrentJobs = $::bacula::maximumConcurrentJobs,) {
  if "$db_type" == "mysql" {
    $db_id = 1
  } else {
    $db_id = 3
  }

  /**
   *
   * /usr/libexec/bacula/grant_mysql_privileges
   * /usr/libexec/bacula/create_mysql_database -u root
   * /usr/libexec/bacula/make_mysql_tables -u bacula
   */
  package { $bacula_dir_package:
    ensure => 'present',
    #    before => Package['bacula-console'],
    notify => Exec['SetDBType'],
  }

  exec { 'SetDBType':
    path        => ['/usr/bin', '/usr/sbin'],
    command     => "alternatives --config libbaccats.so <<< $db_id",
    refreshonly => true,
    notify      => Service[$bacula_dir_service],
  }

  # Install package
  # package { 'bacula-console': ensure => 'present', }

  # start server
  service { $bacula_dir_service:
    ensure     => 'running',
    enable     => true,
    hasrestart => true,
    hasstatus  => true,
    require    => Package[$bacula_dir_package],
  }

  # Create file bacula-dir.conf
  file { "$dirconf/bacula-dir.conf":
    ensure  => 'file',
    owner   => 'bacula',
    group   => 'bacula',
    content => template('bacula/bacula-dir.conf.erb'),
    require => Package[$bacula_dir_package],
  }

  /**
   * # Create file bconsole.conf
   * file { "$dirconf/bconsole.conf":
   *  ensure  => 'file',
   *  owner   => 'bacula',
   *  group   => 'bacula',
   *  content => template('bacula/bconsole.conf.erb'),
   *}
   */

  # Create directory  /bacula to save backup in file
  file { "$::bacula::dirBackupFile":
    ensure  => 'directory',
    recurse => true,
    owner   => 'bacula',
    group   => 'bacula',
    require => Package[$bacula_dir_package],
  }

  # Create directory /etc/bacula/clients to save client conf
  file { "$dirconf/clients":
    ensure  => 'directory',
    recurse => true,
    owner   => 'bacula',
    group   => 'bacula',
    mode    => '0777',
    require => Package[$bacula_dir_package],
  }

  file { "$::bacula::dirconf/clients/client_bacula-dir.conf":
    ensure  => 'file',
    recurse => true,
    owner   => 'bacula',
    group   => 'bacula',
    content => template('bacula/director/client_bacula-dir.conf.erb'),
    require => File["$dirconf/clients"],
  }

  # Create directory /etc/bacula/jobs to save jobs conf
  file { "$dirconf/jobs":
    ensure  => 'directory',
    recurse => true,
    owner   => 'bacula',
    group   => 'bacula',
    require => Package[$bacula_dir_package],
  }

  file { "$dirconf/jobs/job_bacula-dir.conf":
    ensure  => 'file',
    recurse => true,
    owner   => 'bacula',
    group   => 'bacula',
    content => template('bacula/director/job_bacula-dir.conf.erb'),
    require => File["$::bacula::dirconf/jobs"],
  }

  # Create directory /etc/bacula/pool to save pool conf
  file { "$dirconf/pool":
    ensure  => 'directory',
    recurse => true,
    owner   => 'bacula',
    group   => 'bacula',
    require => Package[$bacula_dir_package],
  }

  file { "$dirconf/pool/pool_bacula-dir.conf":
    ensure  => 'file',
    recurse => true,
    owner   => 'bacula',
    group   => 'bacula',
    content => template('bacula/director/pool_bacula-dir.conf.erb'),
    require => File["$dirconf/pool"],
  }

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

}
