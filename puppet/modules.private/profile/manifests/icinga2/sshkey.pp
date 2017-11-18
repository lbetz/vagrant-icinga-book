class profile::icinga2::sshkey {
  File {
    owner   => 'icinga',
    group   => 'icinga',
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
