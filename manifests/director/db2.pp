class bacula::director::db2 (
  
  $db_package = $::bacula::director::db_package
  
  
  
  ,
) inherits bacula::director {
  class { '::mysql::server':
    root_password           => "${::passwordclient}",
    remove_default_accounts => true,
    override_options        => {
      'mysqld' => {
        'max_connections' => '1024'
      }
    }
  }


  exec { 'Grant_mysql_privileges_bacula':
    path    => '/usr/bin:/usr/sbin:/bin:/opt/puppetlabs/bin',
    command => '/usr/libexec/bacula/grant_mysql_privileges',
    require => Class['::mysql::server'],
  }

    exec { 'Create_mysql_database_bacula':
    path    => '/usr/bin:/usr/sbin:/bin:/opt/puppetlabs/bin',
    command => "/usr/libexec/bacula/create_mysql_database -u root -p${::passwordclient}",
    require => Exec['Grant_mysql_privileges_bacula']
   
  }

      exec { 'Make_mysql_tables_bacula':
    path    => '/usr/bin:/usr/sbin:/bin:/opt/puppetlabs/bin',
    command => "/usr/libexec/bacula/make_mysql_tables -u bacula -p${::passwordclient}",
    require => Exec['Create_mysql_database_bacula']
   
  }

}
