class ntp(
  $server = false,
) {

  if $server {
    service { 'chronyd':
      ensure => stopped,
      enable => false,
    }
    ->
    package { 'ntp':
      ensure => installed,
    }
    ->
    file { '/etc/ntp.conf':
      ensure  => file,
      owner   => 'root',
      group   => 'root',
      mode    => '0644',
      source  => 'puppet:///modules/ntp/ntp.conf',
    }
    ~>
    service { 'ntpd':
      ensure  => running,
      enable  => true,
      require => Package['ntp'],
    }
  } else {
    package { 'chrony':
      ensure => installed,
    }
    ->
    service { 'chronyd':
      ensure => running,
      enable => true,
    }
  }

}
