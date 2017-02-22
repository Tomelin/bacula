class bacula::director::db ($db_package = $::bacula::director::db_package,) inherits bacula::director {
  class { '::mysql::server':
    root_password           => "${::passwordclient}",
    remove_default_accounts => true,
    override_options        => {
      'mysqld' => {
        'max_connections' => '1024'
      }
    }
  }

  class { 'mysql::server::service':
    ensure => 'running',
    enable => true,
  }

}

