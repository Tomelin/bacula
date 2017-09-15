class bacula::client::resource (
  $fd_name           = undef,
  $fd_address        = undef,
  $fd_port           = undef,
  $fd_password       = undef,
  $fd_file_retention = undef,
  $fd_job_retention  = undef,
  $fd_auto_prune     = undef,
  $fd_dir_config     = undef,
  $fd_tag            = undef,

  $fd_fileset_name            = undef,
  $fd_fileset_include         = undef,
  $fd_fileset_include_options = undef,
  $fd_fileset_exclude         = undef,
  $fd_fileset_exclude_options = undef,

  $fd_job_name    = undef,
  $fd_job_fileset = undef,
  $fd_job_defs    = undef,
  $fd_job_type    = undef,
  $fd_job_pool    = undef,

  ){

   @@file{ "${fd_dir_config}/conf.d/fd_${fd_name}.conf":
    ensure  => file,
    owner   => 'bacula',
    group   => 'bacula',
    content => epp('bacula/resources/client'),
    tag     => $fd_tag,
   }

}
