class profile::icinga2(
  $ido_dbpassword = 'icinga',
  $web_dbpassword = 'icingaweb2',
) {

  Exec { path => [ '/bin/', '/sbin/' , '/usr/bin/', '/usr/sbin/' ] }

  include ::mysql::server

  class { '::icinga2':
    manage_repo => true,
    features    => ['checker','mainlog','notification','command'],
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

  # Apache
  class { ::apache:
    purge_configs => false
  }

  include ::apache::mod::status
  include ::apache::mod::php

  # Icinga Web 2
  class { '::icingaweb2':
    initialize          => true,
    install_method      => 'package',
    manage_apache_vhost => true,
    ido_db_name         => 'icinga',
    ido_db_pass         => $ido_dbpassword,
    ido_db_user         => 'icinga',
    web_db_name         => 'icingaweb2',
    web_db_user         => 'icingaweb2',
    web_db_pass         => $web_dbpassword,
    require             => Class['::mysql::server'],
  } ->

  augeas { 'php.ini':
    context => '/files/etc/php.ini/PHP',
    changes => ['set date.timezone Europe/Berlin',],
    notify  => Service["httpd"],
  }

  include ::icingaweb2::mod::monitoring

  mysql::db { 'icingaweb2':
    user     => 'icingaweb2',
    password => $web_dbpassword,
    host     => 'localhost',
    grant    => ['ALL'],
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
}
