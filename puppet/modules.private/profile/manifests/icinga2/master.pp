class profile::icinga2::master {

  /* Install Monitoring Plugins */
  include ::profile::icinga2::plugins::monitoring 

  
  /* Manage Icinga 2 with additional features api */
  class { '::icinga2':
    features => [ 'mainlog', 'checker', 'notification', 'api', ],
    require  => Class['::profile::icinga2::plugins::monitoring'],
  }

  /* Create a CA fot Icinga 2 */
  include ::icinga2::pki::ca

  file {
    default:
      owner => 'icinga',
      group => 'icinga',
      mode  => '0640',
    ;
    '/var/spool/icinga2/.ssh':
      ensure  => directory,
      require => Class['icinga2'],
    ;
    '/var/spool/icinga2/.ssh/id_rsa':
      ensure => file,
      mode   => '0600',
      source => 'puppet:///modules/profile/icinga2/id_rsa',
    ;
    '/var/spool/icinga2/.ssh/id_rsa.pub':
      ensure => file,
      source => 'puppet:///modules/profile/icinga2/id_rsa.pub',
    ;
    '/var/spool/icinga2/.ssh/config':
      ensure  => file,
      content => "Host *\n  StrictHostKeyChecking no\n  BatchMode yes",
    ;
    '/etc/icinga2/conf.d':
      ensure  => directory,
      recurse => true,
      source  => "puppet:///modules/profile/icinga2/${::chapter}",
      tag     => 'icinga2::config::file',
      notify  => Class['icinga2::service'],
    ;
  }
     
}
