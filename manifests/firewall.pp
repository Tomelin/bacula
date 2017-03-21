# Class define variables the module firewall 
# You should feel free to expand on this and document any parameters etc
class bacula::firewall (
  $firewall        = $::bacula::firewall,
  $is_client       = $::bacula::is_client,
  $is_storage      = $::bacula::is_storage,
  $is_director     = $::bacula::is_director,
  $is_console      = $::bacula::is_console,
  $is_director_ftp = $::bacula::is_director_ftp,
  $port_ftp        = $::bacula::port_ftp,) {
  if $firewall == true {
    if $::os['release']['major'] == 7 {
      if $is_director == true {
        firewalld_service { 'Open port bacula server in the public zone':
          ensure  => present,
          zone    => 'public',
          service => 'bacula',
        }

        if $is_director_ftp == true {
          if $firewall == true {
            firewalld_port { 'Open port FTP is a protocol used for remote file transfer':
              ensure   => present,
              zone     => 'public',
              port     => $port_ftp,
              protocol => 'tcp',
            }
          }
        }

        # If teh bacula client
      } elsif $is_client == true {
        firewalld_service { 'Open port bacula server in the public zone':
          ensure  => present,
          zone    => 'public',
          service => 'bacula-client',
        }
      }
    }
  }
}