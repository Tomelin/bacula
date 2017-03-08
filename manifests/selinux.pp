class bacula::selinux (
  $firewall         = $::bacula::firewall,
  $is_client        = $::bacula::is_client,
  $is_storage       = $::bacula::is_storage,
  $is_director      = $::bacula::is_director,
  $is_console       = $::bacula::is_console,
  $dirconf          = $::bacula::dirconf,
  $workingdirectory = $::bacula::workingdirectory,
  $piddirectory     = $::bacula::piddirectory,
  $dirrestorefile   = $::bacula::dirrestorefile,
  $dirbaculatmp     = $::bacula::dirbaculatmp,
  $portftp          = '2121') {
  if $::os['selinux']['enabled'] == true {
    notify {'selinux ativado':}
  } 
  
  
  /*
  bacula_spool_t
        /var/spool/bacula.*


bacula_store_t
        /bacula(/.*)?
       /var/bacula(/.*)?

bacula_log_t
      /var/log/bacula/
      * 
      * 
bacula_exec_t
  /usr/sbin/bacula
 
 
 
  * 
/usr/sbin/bat regular file system_u:object_r:bacula_admin_exec_t:s0
*
 /usr/sbin/bconsole regular file system_u:object_r:bacula_admin_exec_t:s0

bacula_tmp_t


bacula_var_lib_t
        /var/lib/bacula.*


bacula_var_run_t
        /var/run/bacula.*
        * 
        * 
        * 
        * 
        * FTP
        * 
        * setsebool -P allow_ftpd_full_access=1
        *  */
        
  }
}