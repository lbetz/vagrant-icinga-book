class drupal::package::bundled (
  $docroot = $drupal::docroot,
  $version = $drupal::drupalversion,
) {

  # TODO: This logic is flawed if a user wants to install to an existing directory.
  file { "/tmp/drupal-${version}.tar.gz":
    ensure => file,
    source => "puppet:///modules/drupal/drupal-${version}.tar.gz",
    before => Exec['install drupal'],
  }
  exec { 'install drupal':
    command => "/bin/tar -xf /tmp/drupal-${version}.tar.gz -C ${docroot}",
    creates => $docroot,
  }

}
