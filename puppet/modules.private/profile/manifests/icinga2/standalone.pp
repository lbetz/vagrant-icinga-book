class profile::icinga2::standalone {
  class { ['::repos::epel', '::repos::icinga']:
    stage => 'repos',
  }

  class { '::icinga2':
    features => [ 'checker', 'mainlog', 'notification', 'command', 'statusdata' ],
  }

  include ::profile::icinga2::plugins::monitoring
  include ::profile::icinga2::classicui

  file { '/etc/icinga2/conf.d/hosts.conf':
    ensure => file,
    owner  => 'icinga',
    group  => 'icinga',
    mode   => '0640',
    content => 'object Host NodeName {
  import "generic-host"

  address = "127.0.0.1"
  address6 = "::1"

  vars.os = "Linux"

  vars.http_vhosts["http"] = {
    http_uri = "/"
  }

  vars.disk_wfree = "20%"
  vars.disk_cfree = "10%"
  vars.disks["disk /"] = {
    disk_partitions = "/"
  }
  vars.disks["disk /boot"] = {
    disk_partitions = "/boot"
    disk_wfree = "10%"
    disk_cfree = "5%"
  }

  vars.notification["mail"] = {
    groups = [ "icingaadmins" ]
  }
}',
  tag => 'icinga2::config::file',
}
}
