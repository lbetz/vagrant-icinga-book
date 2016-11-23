class profile::nagios::plugins {
  class { 'repos::plugins':
    stage => 'repos',
  }

  File {
    owner => 'root',
    group => 'root',
    mode  => '0755',
  }

  package { ['nagios-plugins-all','nagios-plugins-mem']:
    ensure  => installed,
  }

  file { '/usr/lib64/nagios/plugins/check_yum':
    ensure => file,
    source => 'puppet:///modules/profile/icinga2/scripts/check_yum',
  }
}
