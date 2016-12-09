class profile::kibana {
  package { "kibana":
    ensure => 'installed',
  }

  service { 'kibana':
    ensure  => 'running',
    enable  => true,
    require => Package['kibana'],
  }

  file_line { 'kibana_external':
    path    => '/etc/kibana/kibana.yml',
    line    => 'server.host: 0.0.0.0',
    ensure  => 'present',
    match   => '^server.host',
    notify  => Service['kibana'],
    require => Package['kibana'],
  }
}
