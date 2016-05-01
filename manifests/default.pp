node "draco" {
  include profile::base
  include profile::icinga2::agent
  include profile::router
  include dnsmasq
}

node "antlia" {
  include role::webserver
}

node "aquarius" {
  include profile::base
  include profile::icinga2::agent

  class { 'postgresql::server':
    listen_addresses => '*',
  }

  postgresql::server::pg_hba_rule { 'allow application drupal to access drupal database':
    description => "Open up PostgreSQL for access from 172.16.2.12/32",
    type        => 'host',
    database    => 'drupal',
    user        => 'drupal',
    address     => '172.16.2.12/32',
    auth_method => 'md5',
  }
  postgresql::server::db { 'drupal':
    user     => 'drupal',
    password => 'drupal',
  }
  postgresql::server::pg_hba_rule { 'allow icinga to access postgresql':
    description => "Open up PostgreSQL for access from 172.16.1.11/32",
    type        => 'host',
    database    => 'all',
    user        => 'monitor',
    address     => '172.16.1.11/32',
    auth_method => 'md5',
  }
  postgresql::server::role { 'monitor':
    password_hash    => postgresql_password('monitor', 'monitor'),
    connection_limit => 12,
  }
  postgresql::server::grant { 'monitor':
    role        => 'monitor',
    db          => undef,
    object_type => 'ALL SEQUENCES IN SCHEMA',
    object_name => 'public',
    privilege   => 'USAGE',
  }
}

node "fornax" {
  include role::monitorserver
}

node "sculptor" {
  include profile::base
  include profile::icinga2::slave
}

node "gmw" {
  include role::groupware
}

node "kmw" {
  include role::mailrelay
}

node "andromeda" {
}

node default {
  include profile::base
  include profile::icinga2::agent
}
