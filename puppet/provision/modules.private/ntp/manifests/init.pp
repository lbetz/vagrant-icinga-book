class ntp(
  $server = false,
) {

  package { 'ntp':
    ensure => installed,
  }

  -> class { '::ntp::config': }

  ~> service { 'ntpd':
    ensure => running,
    enable => true,
  }

}

class ntp::config {
  if $ntp::server {
    file { '/etc/ntp.conf':
      ensure  => file,
      owner   => 'root',
      group   => 'root',
      mode    => '0644',
      source  => 'puppet:///modules/ntp/ntp.conf',
    }
  }
}
