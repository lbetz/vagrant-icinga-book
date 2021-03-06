class profile::icinga2::icingaweb2(
  $ido_db_name = "icinga",
  $ido_db_user = "icinga",
  $ido_db_pass = hiera('profile::icinga2::master::ido_dbpassword'),
  $web_db_name = "icingaweb2",
  $web_db_user = "icingaweb2",
  $web_db_pass = hiera('profile::icinga2::master::web_db_pass'),
) {

  Exec { path => [ '/bin/', '/sbin/' , '/usr/bin/', '/usr/sbin/' ] }

  mysql::db { $web_db_name:
    user     => $web_db_user,
    password => $web_db_pass,
    host     => 'localhost',
    grant    => ['ALL'],
  }


  class { '::icingaweb2':
    initialize          => true,
    install_method      => 'package',
    manage_apache_vhost => true,
    ido_db_name         => $ido_db_name,
    ido_db_pass         => $ido_db_pass,
    ido_db_user         => $ido_db_user,
    web_db_name         => "icingaweb2",
    web_db_pass         => $web_db_pass,
    web_db_user         => "icingaweb2",
    require             => Class['::mysql::server'],
  }
  ->
  package { 'php-mysql':
    ensure => installed,
    notify  => Service["httpd"],
  }
  ->
  augeas { 'php.ini':
    context => '/files/etc/php.ini/PHP',
    changes => ['set date.timezone Europe/Vienna',],
    notify  => Service["httpd"],
  }

  contain ::icingaweb2::mod::monitoring

}
