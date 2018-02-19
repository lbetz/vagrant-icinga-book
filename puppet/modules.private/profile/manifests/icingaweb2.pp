class profile::icingaweb2(
  $web_db_name = "icingaweb2",
  $web_db_user = "icingaweb2",
  $web_db_pass = "icingaweb2",
) {

  class { '::repos::scl':
    stage => 'repos',
  }

  require ::profile::icinga2::ido
  require ::profile::icinga2::api

  $ido_db_name = $::profile::icinga2::ido::db_name
  $ido_db_user = $::profile::icinga2::ido::db_user
  $ido_db_pass = $::profile::icinga2::ido::db_pass

  include ::apache
  include ::apache::mod::proxy
  include ::apache::mod::proxy_fcgi
  include ::fpm

  apache::custom_config { 'icingaweb2':
    ensure        => present,
    source        => 'puppet:///modules/icingaweb2/examples/apache2/for-mod_proxy_fcgi.conf',
    verify_config => false,
    priority      => false,
  }

  file { '/root/icingaweb2.init.sql':
    ensure => file,
    source => 'puppet:///modules/profile/icinga2/icingaweb2.init.sql',
  }

  -> mysql::db { $web_db_name:
    user     => $web_db_user,
    password => $web_db_pass,
    host     => 'localhost',
    grant    => ['ALL'],
    sql      => '/root/icingaweb2.init.sql',
  }

  -> class { 'icingaweb2':
    import_schema => false,
    db_username   => $web_db_user,
    db_password   => $web_db_pass,
    notify        => Class['fpm'],
  }

  icingaweb2::config::resource{ 'icingaweb_db':
    type        => 'db',
    db_type     => 'mysql',
    host        => 'localhost',
    port        => 3306,
    db_name     => $web_db_name,
    db_username => $web_db_user,
    db_password => $web_db_pass,
  }

  icingaweb2::config::authmethod{ 'icingaweb2':
    backend  => 'db',
    resource => 'icingaweb_db',
    order    => '10',
  }

  file { '/etc/icingaweb2/groups.ini':
    ensure  => file,
    content => '[icingaweb2]
backend = "db"
resource = "icingaweb_db"',
    require => Class['icingaweb2'],
  }

  icingaweb2::config::role{'icingaadmin':
    groups      => 'Administrators',
    permissions => '*',
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

}

