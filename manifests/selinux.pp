class bacula::selinux (
  $firewall          = $::bacula::firewall,
  $is_client         = $::bacula::is_client,
  $is_storage        = $::bacula::is_storage,
  $is_director       = $::bacula::is_director,
  $is_console        = $::bacula::is_console,
  $dirconf           = $::bacula::dirconf,
  $working_directory = $::bacula::working_directory,
  $pid_directory     = $::bacula::pid_directory,
  $dir_restore_file  = $::bacula::dir_restore_file,
  $dir_bacula_tmp    = $::bacula::dir_bacula_tmp,
  $port_ftp          = '2121') {
  if $::os['selinux']['enabled'] == true {
    notify { 'selinux ativado': }

    selinux::fcontext { 'set-mysql-log-context':
      context  => 'bacula_store_t',
      pathname => '/bacula(/.*)?',
    # pathname => '/var/bacula(/.*)?',
    }

  } else {
    notify { 'selinux ativado': }
  }

}