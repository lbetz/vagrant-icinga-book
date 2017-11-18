class profile::icinga2::icingaweb2(
  $ido_db_name = "icinga2",
  $ido_db_user = "icinga2",
  $ido_db_pass = "icinga2",
  $web_db_name = "icingaweb2",
  $web_db_user = "icingaweb2",
  $web_db_pass = "icingaweb2",
) {

  include ::mysql::server
  include ::apache::mod::php

  package { ['php', 'php-mysql']:
    ensure => installed,
    notify => Class['apache'],
  }

  augeas { 'php.ini':
    context => '/files/etc/php.ini/PHP',
    changes => ['set date.timezone Europe/Vienna',],
    require => Package['php'],
    notify  => Class['apache'],
  }

  file {'/etc/httpd/conf.d/icingaweb2.conf':
    ensure => file, 
    source => 'puppet:///modules/icingaweb2/examples/apache2/icingaweb2.conf',
    notify => Service['httpd'],
  }

  class { 'icinga2::feature::idomysql':
    database      => $ido_db_name,
    user          => $ido_db_user,
    password      => $ido_db_pass,
    import_schema => true,
    require       => Mysql::Db[$ido_db_name],
    notify        => Service['httpd'],
  }

  class {'icingaweb2':
    import_schema => true,
    db_username   => $web_db_user,
    db_password   => $web_db_pass,
    require       => Mysql::Db[$web_db_name],
  }

  class {'icingaweb2::module::monitoring':
    ido_host        => 'localhost',
    ido_db_name     => $ido_db_name,
    ido_db_username => $ido_db_user,
    ido_db_password => $ido_db_pass,
    commandtransports => {
      icinga2 => {
        transport => 'api',
        username  => 'root',
        password  => '12e2ef553068b519',
      }
    }
  }

  ::icinga2::object::apiuser { 'root':
    ensure      => present,
    password    => '12e2ef553068b519',
    permissions => [ '*' ],
    target      => '/etc/icinga2/conf.d/api-users.conf',
  }

  mysql::db { $ido_db_name:
    user     => $ido_db_user,
    password => $ido_db_pass,
    host     => 'localhost',
    grant    => ['SELECT', 'INSERT', 'UPDATE', 'DELETE', 'DROP', 'CREATE VIEW', 'CREATE', 'ALTER', 'INDEX', 'EXECUTE'],
  }

  mysql::db { $web_db_name:
    user     => $web_db_user,
    password => $web_db_pass,
    host     => 'localhost',
    grant    => ['ALL'],
  }

}
