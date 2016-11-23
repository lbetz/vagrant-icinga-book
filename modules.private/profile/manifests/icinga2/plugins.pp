class profile::icinga2::plugins {
  include profile::nagios::plugins

  package { [ 'nagios-plugins-postgres',
    'nagios-plugins-mysql_health',
    'nagios-plugins-apache_status',
    'nagios-plugins-nrpe',
    'nagios-plugins-jmx4perl' ]:
    ensure => installed,
  }

  package { 'krb5-workstation':
    ensure => installed,
  }

  file { '/usr/lib64/nagios/plugins/check_kdc':
    ensure => file,
    mode   => '0755',
    source => 'puppet:///modules/profile/icinga2/scripts/check_kdc',
  }

  package { ['squid', 'perl-Nagios-Plugin']:
    ensure => installed,
  }

  file { '/usr/lib64/nagios/plugins/check_squid':
    ensure => file,
    mode   => '0755',
    source => 'puppet:///modules/profile/icinga2/scripts/check_squid',
  }
}
