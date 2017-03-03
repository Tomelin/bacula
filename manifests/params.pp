class bacula::params {
  # Conf default
  $dirconf = "/etc/bacula"
  $workingDirectory = "/var/spool/bacula"
  $pidDirectory = "/var/run/bacula"
  $maximumConcurrentJobs = '30'
  $typebackup = 'file'
  $dirBackupFile = '/bacula'
  $is_client = true
  $is_storage = true
  $is_director = true
  $is_console = false
  $is_directorFTP = true
  $db_type = 'mysql'
  $dirConfClients = "$dirconf/clients"
  $dirConfStorage = "$dirconf/storage"
  $dirBaculaTMP = "/tmp/bacula"
  $portFTP = '2121'
  $db_id = 1
  
  # Bacula client - bacula-fd.conf
  $fdport = "9102"
  $password_fd = "${::passwordclient}"

  # Bacula director - bacula-dir.conf
  $dirport = "9101"
  $bacula_dir = "bacula-dir"
  $heartbeatInterval = "120"
  # Bacula director - bacula-sd.conf
  $sdport = "9103"
  
  
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
          $ftp_package = 'vsftpd'
          $db_package = 'mariadb-server'

        }
        default : {
          notice("\"${module_name}\" provides no config directory and package default values for OS version release \"${::operatingsystemmajrelease}\""
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

}

