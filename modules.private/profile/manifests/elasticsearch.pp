class profile::elasticsearch {

  include java

  package { "elasticsearch":
    ensure => 'installed',
  }

  service { "elasticsearch":
    ensure  => 'running',
    enable  => true,
    require => [
      Package['elasticsearch'],
      Package['java-1.8.0-openjdk'],
      Exec['set_max_map_count'],
      File_line['es_xmx'],
      File_line['es_xms'],
    ],
  }


  file_line { "vm_max_map_count":
    ensure => 'present',
    path => '/etc/sysctl.conf',
    line => 'vm.max_map_count=262144',
    match => '^vm.max_map_count',
  }

  file_line { "es_xms":
    ensure => 'present',
    path   => '/etc/elasticsearch/jvm.options',
    line   => '-Xms512m',
    match  => '^-Xms',
  }

  file_line { "es_xmx":
    ensure => 'present',
    path   => '/etc/elasticsearch/jvm.options',
    line   => '-Xmx512m',
    match  => '^-Xmx',
  }

  exec { "set_max_map_count":
    command => 'echo 262144 > /proc/sys/vm/max_map_count',
    path    => '/bin',
    unless  => 'cat /proc/sys/vm/max_map_count | grep 262144',
  }
}
