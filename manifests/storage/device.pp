#This class define the devices in bacula-sd
define bacula::storage::device (
  String $conf_dir               = '/etc/bacula',
  String $device_name            = $name,
  String $device_media_type      = 'File',
  String $device_archive_device  = '/tmp',
  String $device_label_media     = 'yes',
  String $device_random_access   = 'yes',
  String $device_automatic_mount = 'yes',
  String $device_removable_media = 'no',
  String $device_always_open     = 'no',
  ){

  #  ensure_resource(  'concat', '/etc/bacula/bacula-sd.conf', { 'ensure' => 'present', 'replace' => false } )

    concat::fragment { $device_name:
      target  => '/etc/bacula/bacula-sd.conf',
      content => epp('bacula/storage/device',{
        'device_name' => $device_name,
        'device_media_type' => $device_media_type,
        'device_archive_device' => $device_archive_device,
        'device_label_media' => $device_label_media,
        'device_random_access' => $device_random_access,
        'device_automatic_mount' => $device_automatic_mount,
        'device_removable_media' => $device_removable_media,
        'device_always_open' => $device_always_open,
        }),
        order => '05',
    }


  }
