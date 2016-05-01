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
    source => 'puppet:///modules/profile/ca/ca.crt',
  }
  file { '/etc/postfix/ssl/server.key':
    ensure => file,
    source => 'puppet:///modules/profile/private_keys/gmw.key',
    mode   => '0600',
  }
  file { '/etc/postfix/ssl/server.crt':
    ensure => file,
    source => 'puppet:///modules/profile/certs/gmw.crt',
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
