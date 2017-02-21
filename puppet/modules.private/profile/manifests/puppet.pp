class profile::puppet::agent {

  include ::puppet

}

class profile::puppet::server::master {

  file { '/etc/systemd/system/puppetmaster.service':
    ensure => file,
    mode   => '0755',
    source => 'puppet:///modules/profile/puppet/puppetmaster.service',
  }
  ->
  class { '::puppet':
    server                        => true,
    server_implementation         => 'master',
    server_package                => 'puppetserver',
    server_passenger              => false,
    server_service_fallback       => true,
    agent                         => true,
    server_foreman                => false,
    server_external_nodes         => '',
    vardir                        => '/opt/puppetlabs/server/data/puppetserver',
    server_directory_environments => true,
    server_environments           => [],
    server_dynamic_environments   => true,
    server_reports                => 'store',
    autosign_entries              => ['*.icinga-book.local', '*.icinga-book.net'],
  }
  ->
  class { '::puppetdb::server':
    manage_firewall => false,
    database_host   => 'aquarius.icinga-book.local',
  }
  ->
  class { '::puppetdb::master::config':
    restart_puppet              => false,
    puppetdb_soft_write_failure => true,
  }
  ~>
  exec { 'profile::puppet::server::master':
    path        => '/bin',
    command     => 'systemctl restart puppetmaster',
    refreshonly => true,
  }

  #include foreman
  #include foreman_proxy
}
