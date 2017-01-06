class ntp(
  $server = false,
) {

  package { 'ntp':
    ensure => installed,
  }

  if $ntp::server {
    file { '/etc/ntp.conf':
      ensure  => file,
      owner   => 'root',
      group   => 'root',
      mode    => '0644',
      source  => 'puppet:///modules/ntp/ntp.conf',
      require => Package['ntp'],
      notify  => Service['ntpd'],
    }
  }

  service { 'ntpd':
    ensure  => running,
    enable  => true,
    require => Package['ntp'],
  }

}
