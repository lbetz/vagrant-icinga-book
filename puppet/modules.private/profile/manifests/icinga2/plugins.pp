class profile::icinga2::plugins::monitoring {
  package { 'nagios-plugins-all':
    ensure => installed,
  }
}


class profile::icinga2::plugins {

  case $::osfamily {
    'windows': {
      Class['::icinga2']
      ->
      file { 'C:/ProgramData/icinga2/etc/icinga2/scripts/check_time.vbs':
        ensure             => file,
        source_permissions => ignore,
        source             => 'puppet:///modules/profile/icinga2/scripts/check_time.vbs',
      }
      ->
      file { 'C:/ProgramData/icinga2/etc/icinga2/scripts/check_ad.vbs':
        ensure             => file,
        source_permissions => ignore,
        source             => 'puppet:///modules/profile/icinga2/scripts/check_ad.vbs',
      }
      ->
      file { 'C:/ProgramData/icinga2/etc/icinga2/scripts/check_windows_updates.ps1':
        ensure             => file,
        source_permissions => ignore,
        source             => 'puppet:///modules/profile/icinga2/scripts/check_windows_updates.ps1',
      }
    } # windows

    default: {
      File {
        owner => 'root',
        group => 'root',
        mode  => '0755',
      }

      package { [ 'nagios-plugins-all',
        'perl-Nagios-Plugin',
        'nagios-plugins-mem' ]:
        ensure  => installed,
      }
      ->
      file { '/usr/lib64/nagios/plugins/check_yum':
        ensure => file,
        source => 'puppet:///modules/profile/icinga2/scripts/check_yum',
      }
    } # default
  } # case
}


class profile::icinga2::plugins::extra {

  require profile::icinga2::plugins

  File {
    owner => 'root',
    group => 'root',
    mode  => '0755',
  }

  package { [ 'nagios-plugins-postgres',
    'nagios-plugins-mysql_health',
    'nagios-plugins-apache_status',
    'nagios-plugins-nrpe',
    'nagios-plugins-mssql_health',
    'nagios-plugins-jmx4perl' ]:
    ensure  => installed,
  }
  ->
  file { '/usr/lib64/nagios/plugins/check_kdc':
    ensure => file,
    source => 'puppet:///modules/profile/icinga2/scripts/check_kdc',
  }
  ->
  file { '/usr/lib64/nagios/plugins/check_squid':
    ensure => file,
    source => 'puppet:///modules/profile/icinga2/scripts/check_squid',
  }

  package { ['krb5-workstation', 'squid']:
    ensure => installed,
  }
}
