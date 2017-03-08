class bacula::selinux (
  $firewall         = $::bacula::firewall,
  $is_client        = $::bacula::is_client,
  $is_storage       = $::bacula::is_storage,
  $is_director      = $::bacula::is_director,
  $is_console       = $::bacula::is_console,
  $dirconf          = $::bacula::dirconf,
  $workingDirectory = $::bacula::workingDirectory,
  $pidDirectory     = $::bacula::pidDirectory,
  $dirRestoreFile   = $::bacula::dirRestoreFile,
  $dirBaculaTMP     = $::bacula::dirBaculaTMP,
  $portFTP          = '2121') {
  if $::os['selinux']['enabled'] == true {
    notify {'selinux ativado':}
  }else{
    notify {'selinux ativado':}
  }
}