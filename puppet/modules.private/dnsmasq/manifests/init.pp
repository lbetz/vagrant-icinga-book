class dnsmasq {

  Class['::dnsmasq::install'] -> Class['::dnsmasq::config'] ~> Class['::dnsmasq::service']

  include ::dnsmasq::install, ::dnsmasq::config, ::dnsmasq::service
}

class dnsmasq::install {

  package { 'dnsmasq':
    ensure => installed,
  }

}

class dnsmasq::config {

  File {
    owner => 'root',
    group => 'root',
    mode  => '0644',
  }

  file { '/etc/dnsmasq.d/icinga-book.local':
    ensure => file,
    source => 'puppet:///modules/dnsmasq/icinga-book.local',
  }

  file { '/etc/dnsmasq.d/icinga-book.net':
    ensure => file,
    source => 'puppet:///modules/dnsmasq/icinga-book.net',
  }

  #file { '/etc/hosts.dnsmasq':
  file { '/etc/hosts':
    ensure => file,
    source => 'puppet:///modules/dnsmasq/hosts',
  }

  #  file_line { 'activate own hosts file':
  #  ensure => present,
  #  path   => '/etc/dnsmasq.conf',
  #  line   => 'addn-hosts=/etc/hosts.dnsmasq',
  #  match  => '^#addn-hosts=',
  #}

}

class dnsmasq::service {

  service { 'dnsmasq':
    ensure => running,
    enable => true,
  }

}
