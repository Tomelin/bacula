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
    selinux::fcontext { 'bacula_dir_backup':
      context  => 'bacula_store_t',
      pathname => '/bacula(/.*)?',
    }

    selinux::fcontext { 'bacula_dir_spool':
      context  => 'bacula_spool_t',
      pathname => "${working_directory}.*",
    }
    
    selinux::fcontext { 'bacula_dir_run':
      context  => 'bacula_var_run_t',
      pathname => "${pid_directory}.*",
    }

  }
}

/*
 *
 * bacula_spool_t
 *
 *      /var/spool/bacula.*
 *
 *
 * bacula_store_t
 *
 *      /bacula(/.*)?
 *
 *     /var/bacula(/.*)?
 *
 *
 * bacula_tmp_t
 *
 *
 * bacula_var_lib_t
 *
 *      /var/lib/bacula.*
 *
 *
 * bacula_var_run_t
 *
 *      /var/run/bacula.*
 *
 *
 * cifs_t
 *
 *
 *
 *
 *
 *
 *     bacula_log_t
 */