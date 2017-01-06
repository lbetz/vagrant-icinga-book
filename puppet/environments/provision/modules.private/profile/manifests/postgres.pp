class profile::postgres {

  class { '::postgresql::server':
    listen_addresses => '*',
  }

  # PuppetDB
  class { '::postgresql::server::contrib': }

  postgresql::server::db { 'puppetdb':
    user     => 'puppetdb',
    password => 'puppetdb',
    grant    => 'all',
  }

  postgresql::server::extension { 'pg_trgm':
    database => 'puppetdb',
  }

  postgresql::server::pg_hba_rule { 'allow puppet to access puppetdb':
    description => "Open up PostgreSQL for access from 172.16.1.12/32",
    type        => 'host',
    database    => 'puppetdb',
    user        => 'puppetdb',
    address     => '172.16.1.12/32',
    auth_method => 'md5',
  }

  # Icinga: User grant to monitor the DBMS and databases
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

class profile::postgres::drupal {

  include ::profile::postgres

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
}
