class network($dns = 'yes') {
  if $::osfamily == 'redhat' {
    service { 'firewalld':
      ensure => 'stopped',
      enable => false,
    }

    #    exec { 'selinux-disable':
    #  path    => '/usr/sbin:/usr/bin',
    #  command => 'setenforce 0',
    #  unless  => 'getenforce |/bin/grep -n Permissive 2>&1>/dev/null',
    #}
    #file_line { 'selinux-disable':
    #  path   => '/etc/sysconfig/selinux',
    #  line  => 'SELINUX=permissive',
    #  match => '^SELINUX=',
    #}
    file_line { 'peerdns':
      path   => '/etc/sysconfig/network-scripts/ifcfg-enp0s3',
      line  => "PEERDNS=${dns}",
      match => '^PEERDNS=',
    } ~>
    service { 'network':
      ensure => running,
      enable => true,
    }
  }
}
