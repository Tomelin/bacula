# Class define variables the module bacula - create jobs default
# You should feel free to expand on this and document any parameters etc
class bacula::director::jobs (
  $dirconf                 = $::bacula::dirconf,
) {
  
  file { '/etc/bacula/jobs/job_gfs.conf':
    ensure  => 'file',
    owner   => 'bacula',
    group   => 'bacula',
    content => template('bacula/director/jobs.conf.erb')
  }



}
