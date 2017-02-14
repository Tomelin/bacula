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
  file { "/etc/bacula/jobs/job_$pools[name].conf":
    ensure  => 'file',
    owner   => 'bacula',
    group   => 'bacula',
    content => template('bacula/director/jobs.pp')
  }

}
