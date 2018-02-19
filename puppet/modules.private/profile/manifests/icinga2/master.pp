class profile::icinga2::master::standalone {

  require ::profile::icinga2
  require ::profile::icinga2::ido
  require ::profile::icinga2::api

  ::icinga2::object::zone { ['linux-commands', 'windows-commands']:
    global => true,
  }

  file {
    default:
      owner => 'icinga',
      group => 'icinga',
      mode  => '0640',
    ;
    '/var/spool/icinga2/.ssh':
      ensure  => directory,
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
  }
     
}
