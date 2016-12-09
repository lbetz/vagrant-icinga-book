class profile::filebeat {
  package { "filebeat":
    ensure => 'installed',
  }

  service { "filebeat":
    ensure  => 'running',
    enable  => true,
    require => Package['filebeat'],
  }

  file { "filebeat.yml":
    ensure => "file",
    notify => Service['filebeat'],
    source => 'puppet:///modules/profile/filebeat.yml',
    path   => '/etc/filebeat/filebeat.yml'
  }
}
