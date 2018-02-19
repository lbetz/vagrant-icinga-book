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

  package { 'amavisd-new':
    ensure => installed,
  } ~>

  service { 'amavisd':
    ensure => running,
    enable => true,
    require => Service['clamd@amavisd'],
  } 

  package { 'clamav-server':
    ensure => installed,
  } ->
  file { '/usr/lib/systemd/system/clamd@amavisd.service':
    ensure  => file,
    content => '[Unit]
Description = clamd scanner clamd daemon
After = syslog.target nss-lookup.target network.target

[Service]
Type = simple
ExecStart = /usr/sbin/clamd -c /etc/clamd.d/clamd@amavisd.conf --foreground=yes
Restart = on-failure
PrivateTmp = true',
  } ~>

  exec { 'systemctl-reload-clamd':
    command     => '/bin/systemctl daemon-reload',
    refreshonly => true,
  } ->

  file { '/etc/clamd.d/clamd@amavisd.conf':
    ensure  => file,
    content => 'LogSyslog yes
LocalSocket /var/run/clamd.amavisd/clamd.sock
LocalSocketGroup amavis
User amavis
AllowSupplementaryGroups yes',
  } ~>
 
  service { 'clamd@amavisd':
    ensure => running,
    enable => true,
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
