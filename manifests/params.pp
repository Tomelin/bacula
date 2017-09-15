#Set params the module bacula
class bacula::params {

  # FD bacula - bacula-fd.conf
  $fd_manage									= true
  $fd_version								  = 'latest'
  $fd_dir_config              = '/etc/bacula'
  $fd_file_config             = 'bacula-fd.conf'
  $fd_name                    = $facts['networking']['hostname']
  $fd_port                    = 9102
  $fd_address                 = $facts['networking']['ip']
  $fd_working_directory       = '/var/spool/bacula'
  $fd_pid_directory           = '/var/run'
  $fd_maximum_concurrent_jobs = 30
  $fd_password                = "${::passwordclient}"
  $fd_server                  = "bacula.${facts['networking']['domain']}"
  $fd_mon_name                = 'mon_name'
  $fd_mon_password            = "${::passwordclient}"
  $fd_mon                     = true
  $fd_messages_name           = 'Standard'
  $fd_messages_director       = "bacula.$facts['networking']['domain'] = all, !skipped, !restored"
  $fd_auto_prune              = 'yes'
  $fd_file_retention          = '60 days'
  $fd_job_retention           = '6 months'
  $fd_tag                     = $facts['networking']['domain']

  # SD bacula - bacula-sd.conf
  $sd_manage									= true
  $sd_version								  = 'latest'
  $sd_dir_config              = '/etc/bacula'
  $sd_file_config             = 'bacula-sd.conf'
  $sd_name                    = $facts['networking']['hostname']
  $sd_port                    = 9103
  $sd_address                 = $facts['networking']['ip']
  $sd_working_directory       = '/var/spool/bacula'
  $sd_pid_directory           = '/var/run/bacula'
  $sd_maximum_concurrent_jobs = 30
  $sd_password                = "${::passwordclient}"
  $sd_server                  = "bacula.${facts['networking']['domain']}"
  $sd_mon_name                = 'mon_name'
  $sd_mon_password            = "${::passwordclient}"
  $sd_mon                     = true
  $sd_messages_name           = 'Standard'
  $sd_messages_director       = "bacula.$facts['networking']['domain'] = all, !skipped, !restored"
  $sd_auto_prune              = 'yes'
  $sd_file_retention          = '60 days'
  $sd_job_retention           = '6 months'
  $sd_tag                     = $facts['networking']['domain']
  $sd_db_type                 = 'mysql'

  #Bconsole - bconsole.conf
  $bconsole_manege      = false
  $bconsole_name        = $facts['networking']['hostname']
  $bconsole_dir_port    = 9101
  $bconsole_address     = $facts['networking']['ip']
  $bconsole_password    = "${::passwordclient}"
  $bconsole_dir_config  = '/etc/bacula'
  $bconsole_file_config = 'bconsole.conf'

  # DIR bacula - bacula-dir.conf
  $dir_manage									 = true
  $dir_version								 = 'latest'
  $dir_dir_config              = '/etc/bacula'
  $dir_file_config             = 'bacula-dir.conf'
  $dir_name                    = $facts['networking']['hostname']
  $dir_port                    = 9101
  $dir_address                 = $facts['networking']['ip']
  $dir_working_directory       = '/var/spool/bacula'
  $dir_pid_directory           = '/var/run/bacula'
  $dir_maximum_concurrent_jobs = 30
  $dir_password                = "${::passwordclient}"
  $dir_server                  = "bacula.${facts['networking']['domain']}"
  $dir_mon_name                = 'mon_name'
  $dir_mon_password            = "${::passwordclient}"
  $dir_mon                     = true
  $dir_messages_name           = 'Standard'
  $dir_messages_director       = "bacula.$facts['networking']['domain'] = all, !skipped, !restored"
  $dir_auto_prune              = 'yes'
  $dir_file_retention          = '60 days'
  $dir_job_retention           = '6 months'
  $dir_tag                     = $facts['networking']['domain']
  $dir_db_type                 = 'mysql'

  # Conf default
  $dirconf                    = "/etc/bacula"
  $workingDirectory           = "/var/spool/bacula"
  $pidDirectory               = "/var/run/bacula"
  $maximumConcurrentJobs      = '30'
  $typebackup                 = 'file'
  $dirBackupFile              = '/bacula'
  $is_client                  = true
  $is_storage                 = true
  $is_director                = true
  $is_console                 = false
  $db_type                    = 'mysql'
  $dirConfClients             = "$dirconf/clients"
  $dirConfStorage             = "$dirconf/storage"
  $dirBaculaTMP               = "/tmp/bacula"
  $db_id                       = 1

  # Bacula director - bacula-dir.conf
  $dir_port = "9101"
  $bacula_dir = "bacula-dir"

  # Bacula director - bacula-sd.conf
  $sdport = "9103"

  # Different path and package definitions
  case $facts['os']['name'] {
    'CentOS', 'RedHat' : {
          $dir_service        = 'bacula-dir'
          $dir_package        = 'bacula-dir'
          $fd_package         = 'bacula-client'
          $fd_service         = 'bacula-fd'
          $sd_service         = 'bacula-sd'
          $bconsole_package   = 'bacula-console'

          if "$sd_db_type" == "mysql" {
            $sd_package  = 'bacula-storage-mysql'
            $dir_package = 'bacula-director-mysql'
          }

          $db_package = 'mariadb-server'
        }
    'Debian', 'Ubuntu' : {
          $fd_package         = 'bacula-client'
          $fd_service         = 'bacula-fd'
          $bacula_dir_package = 'bacula-director'
          $bacula_dir_service = 'bacula-dir'
          $bacula_sd_package = 'bacula-storage'
          $bacula_sd_service = 'bacula-sd'
          $bconsole_package = 'bacula-console'
          $db_package = 'mariadb-server'
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
