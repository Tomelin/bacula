class bacula::director::pool (
  $pools = [{
      name               => 'PoolDiario',
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
      name               => 'PoolDiario2',
      poolType           => 'Backup2',
      recycle            => 'yes',
      autoPrune          => 'yes',
      volumeRetention    => '20 days',
      maximumVolumeBytes => '5G',
      maximumVolumes     => '10',
      labelFormat        => 'Local2'
    }]) {
  # $foo = [ 'one', {'second' => 'two', 'third' => 'three'} ]
  # notify{ $foo[1]['third']: }
  # notice( $foo[1]['third'] )
  $teste = $pools[0]['name']

  notify { $pools[0]['name']: }

  file { "/etc/bacula/pool/pool_$teste.conf":
    ensure  => 'file',
    owner   => 'bacula',
    group   => 'bacula',
    content => template('bacula/director/pool_conf.erb')
  }

}
