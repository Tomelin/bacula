class bacula::firewall (
  $firewall    = $::bacula::firewall,
  $is_client   = $::bacula::is_client,
  $is_storage  = $::bacula::is_storage,
  $is_director = $::bacula::is_director,
  $is_console  = $::bacula::is_console,) {
  if $firewall == true {
    # If teh bacula server

    if $is_director == true {
      firewalld_service { 'Open port bacula server in the public zone':
        ensure  => present,
        zone    => 'public',
        service => 'bacula-server',
      }

      if $is_directorFTP == true {
        if $firewall == true {
          firewalld_port { 'Open port FTP is a protocol used for remote file transfer':
            ensure   => present,
            zone     => 'public',
            port     => "$portFTP",
            protocol => 'tcp',
          }
        }
      }

      # If teh bacula client
    } elsif $is_client == true {
      firewalld_service { 'Open port bacula server in the public zone':
        ensure         => present,
        zone           => 'public',
        service        => 'bacula-client',
      }
    }
  }
}