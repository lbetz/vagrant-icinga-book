class profile::icinga2::ido(
  $db_name = 'icinga2',
  $db_user = 'icinga2',
  $db_pass = 'icinga2',
) {

  include ::mysql::server

  mysql::db { $db_name:
    user     => $db_user,
    password => $db_pass,
    host     => 'localhost',
    grant    => ['SELECT', 'INSERT', 'UPDATE', 'DELETE', 'DROP', 'CREATE VIEW', 'CREATE', 'ALTER', 'INDEX', 'EXECUTE'],
  }

  package { 'icinga2-ido-mysql': }

  class { 'icinga2::feature::idomysql':
    database      => $db_name,
    user          => $db_user,
    password      => $db_pass,
    import_schema => true,
    require       => [ Mysql::Db[$db_name], Package['icinga2-ido-mysql'] ],
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
