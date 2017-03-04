class bacula::default (
  # Conf default
  $dirconf               = "/etc/bacula",
  $workingDirectory      = "/var/spool/bacula",
  $pidDirectory          = "/var/run/bacula",
  $maximumConcurrentJobs = '30',
  $typebackup            = 'file',
  $dirBackupFile         = '/bacula',
  $is_client             = true,
  $is_storage            = false,
  $is_director           = true,
  $is_console            = false,
  $is_directorFTP        = true,
  $dirBaculaTMP          = "/tmp/bacula",
  $portFTP               = '2121',
  # Bacula client - bacula-fd.conf
  $fdport                = "9102",
  $password_fd           = "${::passwordclient}",
  # Bacula director - bacula-dir.conf
  $dirport               = "9101",
  $bacula_dir            = "bacula-dir",) inherits bacula::params {
  file { "$dirBaculaTMP":
    ensure => 'directory',
    owner  => 'bacula',
    group  => 'bacula',
  }

  package { 'ftp': ensure => 'present', }

  # workdir
  file { "$workingDirectory":
    ensure  => directory,
    recurse => true,
    owner   => 'bacula',
    group   => 'bacula',
  }

  file { "$pidDirectory":
    ensure  => directory,
    recurse => true,
    owner   => 'bacula',
    group   => 'bacula',
  }
}