class profile::icinga2::plugins::monitoring {

  if $::kernel != 'Linux' {
    include nscp
  } else {
    include ::profile::repo::epel
    include ::profile::repo::plugins

    package { ['nagios-plugins-all', 'nagios-plugins-mem']:
      ensure => installed,
    }
    -> file { '/usr/lib64/nagios/plugins/check_yum':
      ensure => file,
      mode   => '0755',
      source => 'puppet:///modules/profile/icinga2/scripts/check_yum',
    }
  }

}
