class fpm(
  $ensure      = running,
  $enable      = true,
  $manage_repo = false,
) {

  if ( $manage_repo ) {
    package { 'centos-release-scl':
      ensure => installed,
      before => Package['rh-php71-php-fpm'],
    }
  }
  
  package { 'rh-php71-php-fpm':
    ensure => installed,
  }

  -> file_line { 'php_date_time':
    path  => '/etc/opt/rh/rh-php71/php.ini',
    line  => 'date.timezone = Europe/Berlin',
    match => '^;*date.timezone',
  }

  ~> service { 'rh-php71-php-fpm':
    ensure => $ensure,
    enable => $enable,
  }

}
