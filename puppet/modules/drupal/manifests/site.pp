define drupal::site (
  $ensure         = 'present',
  $admin_password = randstr(),
  $database       = $drupal::params::database,
  $dbuser         = $drupal::params::dbuser,
  $dbpassword     = $drupal::params::dbpassword,
  $dbhost         = $drupal::params::dbhost,
  $dbport         = $drupal::params::dbport,
  $dbdriver       = $drupal::params::dbdriver,
  $dbprefix       = $drupal::params::dbprefix,
  $update         = $drupal::params::update,
  $docroot        = $drupal::params::docroot,
  $writeaccess    = $drupal::params::writeaccess,
  $managedatabase = $drupal::params::managedatabase,
  $managevhost    = $drupal::params::managevhost,
) {
  # TODO: more validation
  if ! member(['absent', 'present'], $ensure) {
    fail("drupal::site Ensure value ${ensure} not supported! (absent or present)")
  }
  if ! member(['mysql', 'sqlite', 'pgsql'], $dbdriver) {
    fail("drupal::site Database driver ${dbdriver} not supported! (mysql, pgsql, or sqlite)")
  }
  $root  = "${docroot}/sites/${name}"

  # the name default is handled specially
  if $name == 'default' {
    $vhost = $::fqdn
  }
  else {
    $vhost = $name
  }

  # manage the vhost if requested
  if $managevhost {
    apache::vhost { $vhost:
      ensure     => $ensure,
      vhost_name => '*',
      port       => '80',
      ssl        => false,
      override   => 'all',
      docroot    => $docroot,
    }
  }

  # manage the database if requested
  if $managedatabase {
    # We can only manage databases on localhost
    if member(['localhost', $::ipaddress], $dbhost) {
      drupal::db { $database:
        ensure   => $ensure,
        dbdriver => $dbdriver,
        user     => $dbuser,
        password => $dbpassword,
        before   => File[$root],
      }
    }
  }

  if $ensure == 'absent' {
    file { $root:
      ensure => absent,
      force  => true,
    }
  }
  else {
    File {
      owner => 'root',
      group => 'root',
      mode  => '0644',
    }

    file { $root:
      ensure => directory,
    }

    file { ["${root}/modules", "${root}/themes"]:
      ensure => directory,
      owner  => $writeaccess ? {
        true  => $drupal::params::apacheuser,
        false => 'root',
      }
    }

    file { "${root}/files":
      ensure => directory,
      owner  => $drupal::params::apacheuser,
    }

    file { "${root}/settings.php":
      ensure  => file,
      mode    => '0444',
      content => template('drupal/settings.php.erb'),
    } ->

    exec { "install ${name} drupal site":
      command   => "drush site-install standard --account-pass='${admin_password}' -l ${name} --yes",
      path      => '/usr/local/bin:/bin:/usr/bin',
      unless    => "drush core-status -l ${name} | grep 'bootstrap.*Successful'",
      logoutput => true,
      require   => Class['drupal::drush'],
    }
  }
}
