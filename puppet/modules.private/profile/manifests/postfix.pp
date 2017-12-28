class profile::postfix::mailrelay {

  include ::postfix

  include ::profile::repo::epel

  file_line { 'enable inbound relay':
    ensure  => present,
    path    => '/etc/postfix/transport',
    match   => '^icinga-book.net',
    line    => 'icinga-book.net smtp:172.16.1.13',
    require => Class['::postfix::install'],
  } ~>
  exec { 'generate transport.db':
    command     => '/usr/sbin/postmap /etc/postfix/transport',
    refreshonly => true,
    notify      => Class['::postfix::service'],
  }

  package { ['clamav-server','amavisd-new']:
    ensure => installed,
  }

}

class profile::postfix::groupware {

  include ::postfix

  File {
    owner => 'root',
    group => 'root',
  }

  file { '/etc/postfix/ssl':
    ensure => directory,
    require => Class['::postfix']
  }
  file { '/etc/postfix/ssl/ca.pem':
    ensure => file,
    source => 'puppet:///modules/profile/ssl/ca/ca.crt',
  }
  file { '/etc/postfix/ssl/server.key':
    ensure => file,
    source => 'puppet:///modules/profile/ssl/private_keys/gmw.icinga-book.local.key',
    mode   => '0600',
  }
  file { '/etc/postfix/ssl/server.crt':
    ensure => file,
    source => 'puppet:///modules/profile/ssl/certs/gmw.icinga-book.local.crt',
  }

  package { 'dovecot':
    ensure => installed,
  } ->
  file { '/etc/dovecot/conf.d/10-master.conf':
    ensure => file,
    source => 'puppet:///modules/profile/groupware/dovecot_10-master.conf',
  } ~>
  service { 'dovecot':
    ensure => running,
    enable => true,
  }
}
