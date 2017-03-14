# Class define variables the module bacula - create pool default
# You should feel free to expand on this and document any parameters etc
class bacula::director::pool (
  $pools = [
    {
      name               => 'PoolDiario3',
      poolType           => 'Backup',
      recycle            => 'yes',
      autoPrune          => 'yes',
      volumeRetention    => '30 days',
      maximumVolumeBytes => '1G',
      maximumVolumes     => '100',
      labelFormat        => 'Local-'
    }
    ,
    {
      name               => 'PoolDiario4',
      poolType           => 'Backup',
      recycle            => 'yes',
      autoPrune          => 'yes',
      volumeRetention    => '30 days',
      maximumVolumeBytes => '1G',
      maximumVolumes     => '100',
      labelFormat        => 'Local-'
    }

    ]) {
  file { '/etc/bacula/pool/pool.conf':
    ensure  => 'file',
    owner   => 'bacula',
    group   => 'bacula',
    content => template('bacula/director/pool_conf.erb')
  }
  
    file { '/etc/bacula/pool/pool_gfs.conf':
    ensure  => 'file',
    owner   => 'bacula',
    group   => 'bacula',
    content => template('bacula/director/jobs.conf.erb')
  }
  

  $database_profile_array = [cpu, sysctl]
  $database_profile_hash = {
    cpu              => {
      governor         => ondemand,
      energy_perf_bias => powersave,
    }
    ,
    sysctl           => {
      kernel_sched_min_granularity_ns    => 10000000,
      kernel_sched_wakeup_granularity_ns => 15000000,
      kernel_msgmnb => 6,
    }
  }

}
