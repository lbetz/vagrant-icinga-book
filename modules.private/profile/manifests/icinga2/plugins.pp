class profile::icinga2::plugins {
  include profile::nagios::plugins

  package { [ 'nagios-plugins-postgres',
    'nagios-plugins-mysql_health',
    'nagios-plugins-apache_status',
    'nagios-plugins-nrpe',
    'nagios-plugins-jmx4perl' ]:
    ensure => installed,
  }
}
