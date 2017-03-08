class bacula::director::db2 ($db_package = $::bacula::director::db_package,) inherits bacula::director {
  class { '::mysql::server':
    root_password           => "${::passwordclient}",
    create_root_my_cnf      => true,
    remove_default_accounts => true,
    override_options        => {
      'mysqld' => {
        'max_connections' => '1024'
      }
    }
  }

  mysql::db { 'bacula':
    user     => 'bacula',
    password => "${::passwordclient}",
    host     => 'localhost',
    grant    => ['ALL'],
    require  => Class['::mysql::server'],
    notify   => Exec['Grant_mysql_privileges_bacula'],
  }

  exec { 'Grant_mysql_privileges_bacula':
    path        => '/usr/bin:/usr/sbin:/bin:/opt/puppetlabs/bin',
    command     => "/usr/libexec/bacula/grant_mysql_privileges -u root -p${::passwordclient}",
    refreshonly => true,
    notify      => Exec['Create_mysql_database_bacula'],
  }

  exec { 'Create_mysql_database_bacula':
    path        => '/usr/bin:/usr/sbin:/bin:/opt/puppetlabs/bin',
    command     => "/usr/libexec/bacula/create_mysql_database -u root -p${::passwordclient}",
    refreshonly => true,
    notify      => Exec['Make_mysql_tables_bacula'],
  }

  exec { 'Make_mysql_tables_bacula':
    path        => '/usr/bin:/usr/sbin:/bin:/opt/puppetlabs/bin',
    command     => "/usr/libexec/bacula/make_mysql_tables -u bacula -p${::passwordclient}",
    refreshonly => true,
  }

}
