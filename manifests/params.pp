class bacula::params {
  # Conf default
  $dirconf = "/etc/bacula"
  $workingDirectory = "/var/spool/bacula"
  $pidDirectory = "/var/run"
  $maximumConcurrentJobs = '30'

  # Bacula client - bacula-fd.conf
  $fdport = "9102"

  # Different path and package definitions
  case "${::operatingsystem}" {
    'CentOS' : {
      case "${::operatingsystemmajrelease}" {
        '7'     : {
          $bacula_dir_package = 'bacula-director'
          $bacula_sd_package = 'bbacula-storage'
          $bacula_fd_package = 'bacula-client'
          $bacula_fd_service = 'bacula-fd'
          $bconsole_package = 'bacula-console'

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

