class profile::nagios::plugins {
  class { 'repos::plugins':
    stage => 'repos',
  }

  package { ['nagios-plugins-all','nagios-plugins-mem']:
    ensure  => installed,
  }
}
