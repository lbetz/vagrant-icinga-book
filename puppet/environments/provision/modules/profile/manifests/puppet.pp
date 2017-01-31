class profile::puppet::agent {

  include ::puppet

}

class profile::puppet::server::master {

  file { '/etc/systemd/system/puppetmaster.service':
    ensure => file,
    mode   => '0755',
    source => 'puppet:///modules/profile/puppet/puppetmaster.service',
    before => Class['puppet'],
  }

  class { '::puppet':
    server                        => true,
    server_implementation         => 'master',
    server_package                => 'puppetserver',
    server_passenger              => false,
    server_service_fallback       => true,
    agent                         => true,
    vardir                        => '/opt/puppetlabs/server/data/puppetserver',
    server_puppetdb_host         => $::fqdn,
    server_storeconfigs_backend  => 'puppetdb',
    server_directory_environments => true,
    server_environments           => [],
    server_dynamic_environments   => true,
    server_reports                => 'foreman',
    autosign_entries              => ['*.icinga-book.local', '*.icinga-book.net'],
  }

  class { '::puppetdb':
    manage_firewall   => false,
    require           => Class['::puppet'],
  }

  include foreman
  include foreman_proxy
}
