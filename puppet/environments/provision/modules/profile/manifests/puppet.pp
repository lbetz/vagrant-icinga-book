class profile::puppet::agent {

  include ::puppet

}


class profile::puppet::master {

  class { '::puppet':
    server                      => true,
    server_foreman              => false,
    server_reports              => 'store',
    server_storeconfigs_backend => 'puppetdb',
    server_external_nodes       => '',
    server_environments         => [],
    autosign_entries            => ['icinga-book.local', 'icinga-book.net'],
  }

  class { '::puppetdb::master::config':
    terminus_package    => 'puppetdb-terminus',
    strict_validation   => false,
    manage_storeconfigs => false,
    restart_puppet      => false,
  }

  file { '/etc/hiera.yaml':
    ensure  => file,
    source  => 'puppet:///modules/profile/puppet/hiera.yaml',
    notify  => Class['apache']
  }

  file { '/etc/puppet/hiera.yaml':
    ensure => link,
    target => '../hiera.yaml',
  }

  file { '/etc/puppet/hieradata':
    ensure  => directory,
    recurse => true,
    force   => true,
    purge   => true,
    source  => 'puppet:///modules/profile/puppet/hieradata',
  }

  file { '/etc/puppet/environments/production/manifests':
    ensure  => directory,
    recurse => true,
    force   => true,
    purge   => true,
    source  => 'puppet:///modules/profile/puppet/manifests',
    require => Class['puppet'],
  }
}


class profile::puppet::puppetdb {

  class { '::puppetdb::server':
    manage_firewall   => false,
    database_host     => 'aquarius.icinga-book.local',
    database_password => 'puppetdb',
    confdir           => '/etc/puppetdb/conf.d/',
  }
}
