class profile::icinga2::master(
  $manage_config = false,
  $ido_dbpassword,
  $endpoints,
  $zones,
) {
  include ::mysql::server
  include ::profile::icinga2::base
  include ::profile::icinga2::pki
  include ::profile::icinga2::plugins::additional
  include ::profile::icinga2::sshkey
  include ::vim

  class { '::icinga2':
    confd     => false,
    features  => ['checker','mainlog','notification','statusdata','compatlog','command'],
    constants => {
      'ZoneName' => 'master',
    },
  }

  # Feature: ido-mysql
  class { '::icinga2::feature::idomysql':
    user          => 'icinga',
    password      => $ido_dbpassword,
    import_schema => true,
    require       => Mysql::Db['icinga'],
  }

  mysql::db { 'icinga':
    user     => 'icinga',
    password => $ido_dbpassword,
    host     => 'localhost',
    grant    => ['SELECT', 'INSERT', 'UPDATE', 'DELETE', 'DROP', 'CREATE VIEW', 'CREATE', 'ALTER', 'INDEX', 'EXECUTE'],
  }

  # Feature: api
  class { '::icinga2::feature::api':
    pki             => 'none',
    accept_commands => true,
    endpoints       => $endpoints,
    zones           => $zones,
  }

  icinga2::object::zone { ['global-templates', 'windows-commands', 'linux-commands']:
    global => true,
  }

  # MySQL user to monitor this DBMS
  mysql_user { 'monitor@localhost':
    ensure        => 'present',
    password_hash => mysql_password('monitor'),
    require       => Class['mysql::server'],
  }

  mysql_grant { 'monitor@localhost/*.*':
    ensure     => present,
    privileges => [ 'SELECT' ],
    table      => '*.*',
    user       => 'monitor@localhost',
  }

  # Icinga2 CA
  file { '/var/lib/icinga2/ca':
    ensure             => directory,
    owner              => 'icinga',
    group              => 'icinga',
    recurse            => true,
    force              => true,
    purge              => true,
    source             => 'puppet:///modules/profile/ca/',
    source_permissions => 'ignore',
    tag                => 'icinga2::config::file',
  }

  # Icinga2 configuration of monitored hosts and services
  if $manage_config {
    file { '/etc/icinga2/zones.d':
      ensure             => directory,
      owner              => 'icinga',
      group              => 'icinga',
      recurse            => true,
      force              => true,
      purge              => true,
      source             => 'puppet:///modules/profile/icinga2/zones.d',
      source_permissions => 'ignore',
      tag                => 'icinga2::config::file',
    }
  }
}
