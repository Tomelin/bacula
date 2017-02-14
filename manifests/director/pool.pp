class bacula::director::pool (
  $pools = [
    {
      name               => 'PoolDiario',
      poolType           => 'Backup',
      recycle            => 'yes',
      autoPrune          => 'yes',
      volumeRetention    => '30 days',
      maximumVolumeBytes => '1G',
      maximumVolumes     => '100',
      labelFormat        => 'Local-'
    }
    
    ]) {
  $teste = $pools[0]['name']

  file { "/etc/bacula/pool/pool_$teste.conf":
    ensure  => 'file',
    owner   => 'bacula',
    group   => 'bacula',
    content => template('bacula/director/pool_conf.erb')
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
