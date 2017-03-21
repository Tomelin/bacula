# Class define variables the module bacula-dir for monitored the jobs
# You should feel free to expand on this and document any parameters etc
# Font config => https://github.com/germanodlf/bacula-zabbix
class bacula::monitored (
  $zabbix_bash = $::bacula::zabbix_bash, 
  $zabbix_conf = $::bacula::zabbix_conf,
  $zabbix_server = $::bacula::zabbix_server,
  $zabbix_server_port = $::bacula::zabbix_server_port,
  
) {
  package { 'zabbix-sender': ensure => present, }

  file { "${zabbix_conf}":
    ensure  => file,
    owner   => root,
    group   => bacula,
    mode    => 0640,
    content => template('bacula/director/monitored/bacula-zabbix.conf.erb'),
  }

  file { "${zabbix_bash}":
    ensure  => file,
    owner   => bacula,
    group   => bacula,
    mode    => 0700,
    content => template('bacula/director/monitored/bacula-zabbix.bash.erb'),
  }

}

