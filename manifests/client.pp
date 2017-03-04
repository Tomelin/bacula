class bacula::client (
  
    # Conf default
  $dirconf = "/etc/bacula"
  $workingDirectory = "/var/spool/bacula"
  $pidDirectory = "/var/run/bacula"
  $maximumConcurrentJobs = '30'
  $typebackup = 'file'
  $dirBackupFile = '/bacula'
  $is_client = true
  $is_storage = false
  $is_director = true
  $is_console = false
  $is_directorFTP = true
  $db_type = 'mysql'
  $dirConfClients = "$dirconf/clients"
  $dirConfStorage = "$dirconf/storage"
  $dirBaculaTMP = "/tmp/bacula"
  $portFTP = '2121'
  $db_id = 1
  
  # Bacula client - bacula-fd.conf
  $fdport = "9102"
  $password_fd = "${::passwordclient}"
  $dirconf = "/etc/bacula"
  $workingDirectory = "/var/spool/bacula"
  $pidDirectory = "/var/run/bacula"
  $maximumConcurrentJobs = '30'
  $dirBaculaTMP = "/tmp/bacula"
  $portFTP = '2121'
  

  # Bacula director - bacula-dir.conf
  $dirport = "9101"
  $bacula_dir = "bacula-dir"
  $heartbeatInterval = "120"
  # Bacula director - bacula-sd.conf
  $sdport = "9103",
  ) inherits bacula::params {
    
    
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

  file { "$dirBaculaTMP":
    ensure => 'directory',
    owner  => 'bacula',
    group  => 'bacula',
  }

  file { "$dirBaculaTMP/client_${::hostname}.conf":
    ensure  => 'file',
    owner   => 'bacula',
    group   => 'bacula',
    content => template('bacula/director/client_conf.erb'),
    require => File["$dirBaculaTMP"],
  }

  file { "$dirBaculaTMP/baculaSendConfClient.sh":
    ensure  => 'file',
    owner   => 'bacula',
    group   => 'bacula',
    mode    => '0755',
    content => template('bacula/scripts/baculaSendConfClient.sh.erb'),
    require => File["$dirBaculaTMP"],
    notify  => Exec['SendClientConf'],
  }

  package { 'ftp':
    ensure => 'present',
  }
  
  exec { 'SendClientConf':
    path        => ['/usr/bin', '/usr/sbin'],
    command     => "$dirBaculaTMP/baculaSendConfClient.sh",
    refreshonly => true,
    require => Package['ftp'],
  }

}
