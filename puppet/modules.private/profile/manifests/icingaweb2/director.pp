class profile::icingaweb2::director(
  $api_user = 'director',
  $api_pass = 'miaQuasoes7konga',
  $db_name  = 'director',
  $db_user  = 'director',
  $db_pass  = 'director',
) {

  $confd = $::profile::icinga2::api::confd

  ::icinga2::object::apiuser { $api_user:
    ensure      => present,
    password    => $api_pass,
    permissions => [ '*' ],
    target      => "${confd}/api-users.conf",
  }

  mysql::db { $db_name:
    user     => $db_user,
    password => $db_pass,
    host     => 'localhost',
    grant    => ['ALL'],
  }

  package { 'git':
    ensure => installed,
    before => Class['icingaweb2::module::director'],
  }

  class { '::icingaweb2::module::director':
    git_revision  => 'v1.4.2',
    db_host       => 'localhost',
    db_name       => $db_name,
    db_username   => $db_user,
    db_password   => $db_pass,
    import_schema => true,
    kickstart     => true,
    endpoint      => $::fqdn,
    api_username  => 'director',
    api_password  => $api_pass,
    require       => Mysql::Db['director']
  }

}

