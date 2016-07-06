class profile::icinga2::base {
  include icinga2
  include icinga2::feature::api

  if $::kernel != 'windows' {
    include profile::nagios::plugins

    user { 'icinga':
      ensure  => present,
      shell   => '/bin/bash',
      groups  => [ 'nagios' ],
      require => Package['icinga2'],
      notify  => Class['icinga2::service'],
    }

    ssh_authorized_key { 'icinga@fornax':
      ensure  => present,
      key     => 'AAAAB3NzaC1yc2EAAAADAQABAAACAQCp6KmsaI43afIYVMqNiujdMww9ZaVNwH0vpMZUw6W8ichvR533jyLbg25E15oXS0fAyQ3t+4B5QxuUPCZodJHUf3ZCnKL1hzZzboQt9XrCuiQC+8xo97sYP1iD+bhWbsZVMeJQXXZH1S/B5j6t/k5WBs7QTLNG4foXZYPwKdd8aar/0H7y6/ASJ0unVcvUgbP/75/CoW+8DQuUQU6zFFFakUWsW2YVxfpHHMGDVnkTr4OIocZxSOQ7g6csVSHHgivUCt1aAPQmVj9FnL9b4o9e1pTVUCi6uJqzTRXlFG8OLXSjhDoHNfNd7UCoKefcdWUzGd1tRCtbbvzMGcH0JzaMw7VF/Xx8E6KBo9c///LxuJjMHZSLe4P881LbY/gXhB3iwLAMapESSpbRZ3QRrRK1deAdZaKRuEJym7boIpAMsrsyuQ0Ky3TuBAVR7/RNAQiCGlcVbiQlZCKGfDqg9guuafOTcyPP2VclSnsoIdK2tlp6EaMu9nYmlHFdeaix0KLezAKRyEJUHZ1hz/f0G2n/iSUxLeGk4ToG9FIPSKhOCA+0GYnTOvVEmSUUpjTi387G5xjBdKhOTG5w+KL81/HEgX2i7eyGsY0ZBxEPKBTFzwu0HUz+nzetB8n8AXmvAw4Kju5o6gGaNcCgtnqWTIcmuRyfKXoR1qKoyFzrFkl2Xw==',
      type    => 'ssh-rsa',
      user    => 'icinga',
      require => Class['icinga2'],
    }

    file_line { 'disable_conf.d':
      ensure  => absent,
      path    => '/etc/icinga2/icinga2.conf',
      line    => 'include_recursive "conf.d"',
      notify  => Class['icinga2::service'],
    }

    file_line { 'enable_contrib_plugins':
      ensure  => present,
      path    => '/etc/icinga2/icinga2.conf',
      line    => 'include <plugins-contrib>',
      match   => '// include <plugins-contrib>',
      notify  => Class['icinga2::service'],
    }
  }
}

class profile::icinga2::plugins {
  include profile::nagios::plugins

  package { [ 'nagios-plugins-postgres',
    'nagios-plugins-mysql_health',
    'nagios-plugins-apache_status',
    'nagios-plugins-jmx4perl' ]:
    ensure => installed,
  }
}

class profile::icinga2::ssh {
  File {
    owner => 'icinga',
    group => 'icinga',
  }

  file { '/var/spool/icinga2/.ssh':
    ensure => directory,
    mode   => '0700',
  }

  file { '/var/spool/icinga2/.ssh/id_rsa':
    ensure => file,
    mode   => '0600',
    source => 'puppet:///modules/profile/icinga2/id_rsa',
  }

  file { '/var/spool/icinga2/.ssh/id_rsa.pub':
    ensure => file,
    mode   => '0644',
    source => 'puppet:///modules/profile/icinga2/id_rsa.pub',
  }

  file { '/var/spool/icinga2/.ssh/config':
    ensure  => file,
    mode    => '0644',
    content =>
'Host *
  StrictHostKeyChecking no
  BatchMode yes
',
  }
}

class profile::icinga2::master {
  include profile::icinga2::base
  include profile::icinga2::ssh
  include mysql::server
  include icinga2::feature::idomysql
  include profile::icinga2::plugins

  File {
    owner => 'icinga',
    group => 'icinga',
  }

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

  file { '/var/lib/icinga2/ca':
    ensure  => directory,
    recurse => true,
    source  => 'puppet:///modules/profile/ca/',
    require => Class['icinga2'],
  }

  file { '/etc/icinga2/zones.d':
    ensure  => directory,
    recurse => true,
    purge   => true,
    source  => 'puppet:///modules/profile/icinga2/zones.d',
  }

}

class profile::icinga2::slave {
  include profile::icinga2::base
  include profile::icinga2::ssh
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

class profile::icinga2::classicui {
  include profile::apache

  package { 'icinga2-classicui-config':
    ensure => installed,
  } ->
  package { 'icinga-gui':
    ensure => installed,
    notify => Class['icinga2::service','apache'],
  }
}
