

REPO CENTOS
  yumrepo { "IUS":
      name => "Bacula backports from rawhide",
      baseurl => 'http://repos.fedorapeople.org/repos/slaanesh/bacula/epel-$releasever/$basearch/',
     gpgkey => "http://repos.fedorapeople.org/repos/slaanesh/bacula/RPM-GPG-KEY-slaanesh",
      descr => "teste-tomelin Bacula backports from rawhide",
      enabled => 1,
      gpgcheck => 1
   }

FIREWALL
client - port 9102
dir - 9101
storage - 9103


SELINUX
[root@centos-6 ~]# ls -laZ /var/spool
drwxr-xr-x. root   root   system_u:object_r:var_spool_t:s0 .
drwxr-xr-x. root   root   system_u:object_r:var_t:s0       ..
drwxr-xr-x. abrt   abrt   system_u:object_r:abrt_var_cache_t:s0 abrt
drwx------. abrt   abrt   system_u:object_r:public_content_rw_t:s0 abrt-upload
drwxr-xr-x. root   root   system_u:object_r:system_cron_spool_t:s0 anacron
drwx------. daemon daemon system_u:object_r:user_cron_spool_t:s0 at
drwxr-x---. bacula bacula system_u:object_r:bacula_spool_t:s0 bacula


 ls -Zla /var/run/bacula-fd.9102.pid 
-rw-r-----. 1 unconfined_u:object_r:bacula_var_run_t:s0 root root 6 Sep  6 17:13 /var/run/bacula-fd.9102.pid

http://sysadm.mielnet.pl/bacula-and-selinux-denying-access/
https://www.systutorials.com/docs/linux/man/8-bacula_selinux/
