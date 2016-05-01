class profile::icinga2::base {
  include icinga2
  include icinga2::feature::api
  include profile::nagios::plugins

  user { 'icinga':
    ensure  => present,
    groups  => [ 'nagios' ],
    require => Class['icinga2::install'],
    notify  => Class['icinga2::service'],
  }

  file_line { 'disable_conf.d':
    ensure => absent,
    path   => '/etc/icinga2/icinga2.conf',
    line   => 'include_recursive "conf.d"',
    notify => Class['icinga2::service'],
  }

  file_line { 'enable_contrib_plugins':
    ensure => present,
    path   => '/etc/icinga2/icinga2.conf',
    line   => 'include <plugins-contrib>',
    match  => '// include <plugins-contrib>',
    notify => Class['icinga2::service'],
  }
}

class profile::icinga2::plugins {
  include profile::nagios::plugins

  package { ['nagios-plugins-postgres',
    'nagios-plugins-mysql_health',
    'nagios-plugins-apache_status']:
    ensure => installed,
  }
}

class profile::icinga2::master {
  include profile::icinga2::base
  include mysql::server
  include icinga2::feature::idomysql
  include profile::icinga2::plugins

  mysql::db { 'icinga':
    user     => 'icinga',
    password => 'icinga',
    host     => 'localhost',
    grant    => ['SELECT', 'INSERT', 'UPDATE', 'DELETE', 'DROP', 'CREATE VIEW', 'CREATE', 'ALTER', 'INDEX', 'EXECUTE'],
    before   => Class['icinga2::feature::idomysql'],
  }

  mysql_user { 'monitor@localhost':
    ensure        => 'present',
    password_hash => mysql_password('monitor')
  }

  mysql_grant { 'monitor@localhost/*.*':
    ensure     => present,
    privileges => [ 'SELECT' ],
    table      => '*.*',
    user       => 'monitor@localhost',
  }

  icinga2::endpoint { 'sculptor':
    host => '172.16.2.11'
  }
  icinga2::zone { 'dmz':
    endpoints => [ 'sculptor' ],
    parent    => 'master',
  }
  icinga2::zone { ['global-templates', 'windows-commands', 'linux-commands']:
    global => true,
  }

  File {
    owner => 'icinga',
    group => 'icinga',
  }

  package { 'icinga2-classicui-config':
    ensure => installed,
  } ->
  package { 'icinga-gui':
    ensure => installed,
    notify => Class['icinga2::service'],
  } ->
  service { 'httpd':
    ensure => running,
    enable => true,
  }

  file { '/var/lib/icinga2/ca':
    ensure  => directory,
    recurse => true,
    source  => 'puppet:///modules/profile/ca/',
    require => Class['icinga2'],
  }

  file { '/etc/icinga2/zones.d':
    ensure  => directory,
    recurse => true,
    source  => 'puppet:///modules/profile/icinga2/zones.d',
  }

}

class profile::icinga2::slave {
  include profile::icinga2::base
  include profile::icinga2::plugins

  icinga2::endpoint { 'fornax':
    host => '172.26.1.11',
  }
  icinga2::zone { 'master':
    endpoints => [ 'fornax' ],
  }
  icinga2::zone { ['global-templates', 'windows-commands', 'linux-commands']:
    global => true,
  }
}

class profile::icinga2::agent {
  include profile::icinga2::base

  if has_ip_network('172.16.1.0') {
    icinga2::endpoint { 'fornax':
      host => '172.16.1.11',
    }
    icinga2::zone { 'master':
      endpoints => [ 'fornax' ],
    }
  } else {
    icinga2::endpoint { 'sculptor':
      host   => '172.16.2.11',
    }
    icinga2::zone { 'dmz':
      endpoints => [ 'sculptor' ],
    }
  }

}
