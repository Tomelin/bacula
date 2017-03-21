# Class define variables the module bacula
# You should feel free to expand on this and document any parameters etc
class bacula::params {
  # Conf default
  $dirconf = '/etc/bacula'
  $working_directory = '/var/spool/bacula'
  $pid_directory = '/var/run/bacula'
  $maximum_concurrent_jobs = '30'
  $typebackup = 'file'
  $dir_backup_file = '/bacula/backup/'
  $dir_restore_file = '/bacula/restore/'
  $dir_backup_default = '/bacula/'
  $is_client = true
  $is_storage = false
  $is_director = false
  $is_console = false
  $is_director_ftp = false
  $db_type = 'mysql'
  $dir_conf_clients = "${dirconf}/clients"
  $dir_conf_storage = "${dirconf}/storage"
  $dir_bacula_tmp = '/tmp/bacula'
  $port_ftp = '2121'
  $server_ftp = 'UNSET'
  $db_id = 1
  $emails = ['root@localhost', 'rafael@tomelin.eti.br']
  $signature = 'MD5'
  $compression = 'GZIP'
  $firewall = true
  $is_monitored = false
  $zabbix_bash = '/var/spool/bacula/bacula-zabbix.bash'
  $zabbix_conf = '/etc/bacula/bacula-zabbix.conf'
  $zabbix_server = "zabbix.${::domain}"
  $zabbix_server_port = '10051'

  # Bacula client - bacula-fd.conf
  $fdport = '9102'
  $password_fd = "${::passwordclient}"

  # Bacula director - bacula-dir.conf
  $dirport = '9101'
  $dirserver = 'bacula-dir'
  $heartbeat_interval = '120'
  # Bacula director - bacula-sd.conf
  $sdport = '9103'

  # Different path and package definitions
  case "${::operatingsystem}" {
    'CentOS' : {
      case "${::operatingsystemmajrelease}" {
        '7'     : {
          $bacula_dir_package = 'bacula-director'
          $bacula_dir_service = 'bacula-dir'
          $bacula_sd_package = 'bacula-storage'
          $bacula_sd_service = 'bacula-sd'
          $bacula_fd_package = 'bacula-client'
          $bacula_fd_service = 'bacula-fd'
          $bconsole_package = 'bacula-console'
          $db_package = 'mariadb-server'
        }
        '6'     : {
          $bacula_dir_package = 'bacula-director'
          $bacula_dir_service = 'bacula-dir'
          $bacula_sd_package = 'bacula-storage'
          $bacula_sd_service = 'bacula-sd'
          $bacula_fd_package = 'bacula-client'
          $bacula_fd_service = 'bacula-fd'
          $bconsole_package = 'bacula-console'
          $db_package = 'mariadb-server'
        }
        default : {
          notice("\"${module_name}\" provides no config directory and package for OS version release \"${::operatingsystemmajrelease}\""
          )
        }
      }
    }
    default  : {
      $exports_file = undef
      $idmapd_file = undef
      $defaults_file = undef
      $server_packages = undef
      $client_packages = undef
      notice("\"${module_name}\" provides no config directory and package default values for OS family \"${::osfamily}\"")
    }
  }

  user { 'bacula':
    ensure     => present,
    name       => 'bacula',
    comment    => 'Bacula Backup System',
    managehome => true,
    home       => '/var/spool/bacula',
    shell      => '/sbin/nologin',
  }

  # directorys default the bacula
  file { "${dir_bacula_tmp}":
    ensure  => directory,
    owner   => 'bacula',
    group   => 'bacula',
    require => User['bacula'],
  }

  package { 'ftp': ensure => 'present', }

  # workdir
  file { "${working_directory}":
    ensure  => directory,
    recurse => true,
    owner   => 'bacula',
    group   => 'bacula',
    mode    => '6744',
    require => User['bacula'],
  }

  file { "${pid_directory}":
    ensure  => directory,
    recurse => true,
    owner   => 'bacula',
    group   => 'bacula',
    mode    => '6744',
    require => User['bacula'],
  }

  file { $dir_backup_default:
    ensure  => 'directory',
    recurse => true,
    owner   => 'bacula',
    group   => 'bacula',
    require => User['bacula'],
  }

  file { $dir_restore_file:
    ensure  => 'directory',
    recurse => true,
    owner   => 'bacula',
    group   => 'bacula',
    require => File[$dir_backup_default],
  }

}

