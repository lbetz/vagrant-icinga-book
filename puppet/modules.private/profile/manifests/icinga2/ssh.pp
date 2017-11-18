class profile::icinga2::ssh {

  include ::profile::icinga2::plugins::monitoring

  user { 'icinga':
    ensure => present,
    home   => '/var/spool/icinga2',
  }

  file { 
    default:
      owner => 'icinga',
      group => 'icinga',
      mode  => '0640',
    ;
    ['/var/spool/icinga2', '/var/spool/icinga2/.ssh']:
      ensure => directory,
    ;
    '/var/spool/icinga2/.ssh/authorized_keys':
      ensure => file,
      source => 'puppet:///modules/profile/icinga2/id_rsa.pub',
    ;
  }

}
