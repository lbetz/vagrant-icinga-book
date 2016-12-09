class profile::logstash {

  include "java"

  package { "logstash":
    ensure  => 'installed',
    require => Package['java-1.8.0-openjdk'],
  }


  exec { "create_logstash_service":
    command => '/usr/share/logstash/bin/system-install',
    require => Package['logstash'],
    creates => '/etc/systemd/system/logstash.service',
  }

  service { "logstash":
    ensure  => 'running',
    enable  => true,
    require => Exec['create_logstash_service'],
  }

  file_line { "logstash_config_reload":
    path => '/etc/logstash/logstash.yml',
    line => 'config.reload.automatic: true',
    match => '^config.reload.automatic:',
    notify => Service['logstash'],
  }

  file_line { "logstash_api":
    path => '/etc/logstash/logstash.yml',
    line => 'http.host: "0.0.0.0"',
    match => '^http.host:',
    notify => Service['logstash'],
  }
}
