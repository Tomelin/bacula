# Class define variables the module selinux - configure selinux for server
# You should feel free to expand on this and document any parameters etc
class bacula::selinux (
  $firewall           = $::bacula::firewall,
  $is_client          = $::bacula::is_client,
  $is_storage         = $::bacula::is_storage,
  $is_director        = $::bacula::is_director,
  $is_console         = $::bacula::is_console,
  $dirconf            = $::bacula::dirconf,
  $working_directory  = $::bacula::working_directory,
  $pid_directory      = $::bacula::pid_directory,
  $dir_restore_file   = $::bacula::dir_restore_file,
  $dir_bacula_tmp     = $::bacula::dir_bacula_tmp,
  $dir_backup_default = $::bacula::dir_backup_default,
  $port_ftp           = $::bacula::port_ftp,) {
  if $::os['selinux']['enabled'] == true {
    if $is_director == true {
      exec { 'context_clients':
        command => 'semanage fcontext -a -t public_content_rw_t "/etc/bacula/clients(/.*)?"',
        path    => '/usr/bin:/usr/sbin:/bin',
        unless  => 'ls -lZ /etc/bacula/ | grep -v public_content_rw_t',
      }

      exec { 'semanage_port_ftp':
        command => "semanage port -a -t ftp_port_t -p tcp ${port_ftp}",
        path    => '/usr/bin:/usr/sbin:/bin',
        unless  => "semanage port -l | grep ftp_port_t | grep  ${port_ftp}",
      }

      exec { 'sebool_ftp':
        command => 'setsebool -P ftpd_full_access 1',
        path    => '/usr/bin:/usr/sbin:/bin',
        unless  => 'getsebool ftpd_full_access | grep on',
      }
    }

    exec { 'bacula_dir_restore':
      command => "semanage fcontext -a -t bacula_store_t ${dir_restore_file}(.*)?",
      path    => '/usr/bin:/usr/sbin:/bin',
      unless  => "ls -lZ ${dir_backup_default} | grep  bacula_store_t",
    }

  }
}

