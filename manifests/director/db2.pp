class bacula::director::db (

  $db_type = $title,

) inherits bacula::director {

  if "$db_type" == "mysql" {
    $db_id = 1

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
      require => Class['::mysql::server'],
    }

    exec { 'Make_mysql_tables_bacula':
      path    => '/usr/bin:/usr/sbin:/bin:/opt/puppetlabs/bin',
      command => "/usr/libexec/bacula/make_mysql_tables -u bacula -p${::passwordclient}",
      require => Exec['Create_mysql_database_bacula']
    }

  } else {
    $db_id = 3
  }
  exec { 'SetDBType':
    path        => ['/usr/bin', '/usr/sbin'],
    command     => "alternatives --config libbaccats.so <<< $db_id",
    refreshonly => true,
    notify      => bacula::director::Service[::bacula::director::dir_service],
  }

}
