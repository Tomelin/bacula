class bacula::client(
  
  $bacula_fd_package = $::bacula::bacula_fd_package,
  $bacula_fd_service = $::bacula::bacula_fd_service,
  $dirconf = $::bacula::dirconf,
  
){
  
  package { $bacula_fd_package:
    ensure => 'present'    
  }
  
  service { $bacula_fd_service:
    ensure => 'running',
    enable => true,
    hasrestart => true,
    hasstatus  => true,
    require => Package[$bacula_fd_package],
    }
  
  file { "$dirconf/bacula-fd.conf":
    ensure => 'file',
    owner => 'bacula',
    group => 'bacula',
    content => template('bacula/bacula-fd.conf.erb'),
    require => Package[$bacula_fd_package],
    notify => Service[$bacula_fd_service]
 }

 }
