class profile::icinga2::icingaweb2(
  $web_db_name = "icingaweb2",
  $web_db_user = "icingaweb2",
  $web_db_pass = "icingaweb2",
) {

  include ::profile::icinga2
  include ::profile::icinga2::ido
  include ::profile::icinga2::api

  include ::apache
  include ::apache::mod::proxy
  include ::apache::mod::proxy_fcgi

  package { 'centos-release-scl': }
  -> package { 'rh-php71-php-fpm': }
  -> file_line { 'php_date_time':
    path  => '/etc/opt/rh/rh-php71/php.ini',
    line  => 'date.timezone = Europe/Berlin',
    match => '^;*date.timezone',
  }
  ~> service { 'rh-php71-php-fpm':
    ensure => running,
    enable => true,
  }

  $ido_db_name = $::profile::icinga2::ido::db_name
  $ido_db_user = $::profile::icinga2::ido::db_user
  $ido_db_pass = $::profile::icinga2::ido::db_pass

  file { '/etc/httpd/conf.d/icingaweb2.conf':
    ensure => file, 
    source => 'puppet:///modules/icingaweb2/examples/apache2/for-mod_proxy_fcgi.conf',
    notify => Service['httpd'],
  }

  class { 'icingaweb2':
    import_schema => true,
    db_username   => $web_db_user,
    db_password   => $web_db_pass,
    require       => [ Mysql::Db[$web_db_name], Class['icinga2'], Package['centos-release-scl'] ],
    notify        => Service['rh-php71-php-fpm'],
  }

  class { 'icingaweb2::module::monitoring':
    ido_host        => 'localhost',
    ido_db_name     => $ido_db_name,
    ido_db_username => $ido_db_user,
    ido_db_password => $ido_db_pass,
    commandtransports => {
      icinga2 => {
        transport => 'api',
        username  => 'icingaweb2',
        password  => '12e2ef553068b519',
      }
    }
  }

  mysql::db { $web_db_name:
    user     => $web_db_user,
    password => $web_db_pass,
    host     => 'localhost',
    grant    => ['ALL'],
  }

}


class profile::icinga2::icingaweb2::director(
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

  class {'icingaweb2::module::director':
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
