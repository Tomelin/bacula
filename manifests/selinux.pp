class bacula::selinux ( 
  
  
){

  if $::facts['os']['selinux']['enabled']  == true {
    file {'/tmp/selinuxok':
      ensure => present,
    }
    $selinuxConf = true
  }else{
    $selinuxConf = false
  }
  
}
