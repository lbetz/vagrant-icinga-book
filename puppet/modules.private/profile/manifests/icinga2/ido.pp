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

}
