class bacula::director::pool (
  $pools = [
    {
      name => 'PoolDiario'
    }
    ,
    {
      poolType => 'Backup'
    }
    ,
    {
      recycle => 'yes'
    }
    ,
    {
      autoPrune => 'yes'
    }
    ,
    {
      volumeRetention => '30 days'
    }
    ,
    {
      maximumVolumeBytes => '1G'
    }
    ,
    {
      maximumVolumes => '100'
    }
    ,
    {
      labelFormat => 'Local-'
    }
    ,
    ]) {
  file { "/etc/bacula/pool/pool_$pools[name].conf":
    ensure  => 'file',
    owner   => 'bacula',
    group   => 'bacula',
    content => template('bacula/director/pool_conf.erb')
  }

}
