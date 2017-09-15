class bacula::storage::storage (
  $sd_name           = undef,
  $sd_address        = undef,
  $sd_port           = undef,
  $sd_password       = undef,
  $sd_dir_config     = undef,
  $sd_tag            = undef,  ){

   @@file{ "${sd_dir_config}/conf.d/sd_${sd_name}.conf":
    ensure  => file,
    owner   => 'bacula',
    group   => 'bacula',
    content => epp('bacula/resources/storage'),
    tag     => $sd_tag,
   }
}
