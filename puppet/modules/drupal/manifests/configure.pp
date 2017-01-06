class drupal::configure {

  if $drupal::installtype == 'package' {
    file { $drupal::docroot:
      ensure => link,
      target => $drupal::installroot,
    }
  }

  file { "${docroot}/.htaccess":
    ensure  => file,
    source  => 'puppet:///modules/drupal/htaccess',
    require => Package['drupal7'],
  }

  drupal::site { 'default':
    ensure         => present,
    admin_password => $drupal::admin_password,
    database       => $drupal::database,
    dbuser         => $drupal::dbuser,
    dbpassword     => $drupal::dbpassword,
    dbhost         => $drupal::dbhost,
    dbport         => $drupal::dbport,
    dbdriver       => $drupal::dbdriver,
    dbprefix       => $drupal::dbprefix,
    update         => $drupal::update,
    docroot        => $drupal::docroot,
    writeaccess    => $drupal::writeaccess,
    managedatabase => $drupal::managedatabase,
    managevhost    => $drupal::managevhost,
  }

}