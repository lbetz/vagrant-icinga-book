class profile::puppetmaster {

  class { 'puppet':
    server                => true,
    server_foreman        => false,
    server_reports        => 'store',
    server_external_nodes => '',
    server_environments   => [],
    autosign_entries      => ['*'],
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
