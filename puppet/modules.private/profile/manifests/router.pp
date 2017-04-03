class profile::router {
  file_line { 'ip_forward':
    ensure => present,
    path   => '/etc/sysctl.conf',
    line   => 'net.ipv4.ip_forward=1',
    match  => '^net.ipv4.ip_forward',
  } ~>
  exec { 'sysctl':
    path        => '/sbin:/usr/bin',
    command     => '/sbin/sysctl -p',
    refreshonly => true,
    unless      => 'cat /proc/sys/net/ipv4/ip_forward |grep -n 1 2>&1>/dev/null'
  }
  file_line { 'ip_masquerade':
    ensure => present,
    path   => '/etc/rc.local',
    line   => '/sbin/iptables -t nat -A POSTROUTING -o eth0 -j MASQUERADE',
  } ~>
  exec { 'rc.local':
    path        => '/sbin:/usr/bin',
    command     => '/bin/bash /etc/rc.d/rc.local',
    refreshonly => true,
    unless      => '/sbin/iptables -L -n -t nat|/bin/grep "MASQUERADE  all  --  0.0.0.0/0            0.0.0.0/0" 2>&1>/dev/null',
  } ->
  file { '/etc/rc.d/rc.local':
    ensure => file,
    mode   => '0755',
  }
}
