class drupal (
  $admin_password = randstr(),
  $database       = $drupal::params::database,
  $dbuser         = $drupal::params::dbuser,
  $dbpassword     = $drupal::params::dbpassword,
  $dbhost         = $drupal::params::dbhost,
  $dbport         = $drupal::params::dbport,
  $dbdriver       = $drupal::params::dbdriver,
  $dbprefix       = $drupal::params::dbprefix,
  $installtype    = $drupal::params::installtype,
  $update         = $drupal::params::update,
  $docroot        = $drupal::params::docroot,
  $writeaccess    = $drupal::params::writeaccess,
  $packagename    = $drupal::params::packagename,
  $drupalversion  = $drupal::params::drupalversion,
  $drushversion   = $drupal::params::drushversion,
  $managedatabase = $drupal::params::managedatabase,
  $managevhost    = $drupal::params::managevhost,
) inherits drupal::params {
  include apache
  include apache::mod::php

  if ! member(['package', 'bundled', 'remote'], $installtype) {
    fail("drupal: Install type ${installtype} not supported! (package, bundled, or remote)")
  }
  if ! member(['mysql', 'sqlite', 'pgsql', 'none'], $dbdriver) {
    fail("drupal: Database driver ${dbdriver} not supported! (mysql, pgsql, or sqlite)")
  }

  anchor { 'drupal::begin': }
  -> class { 'drupal::drush': }
  -> class { "drupal::package::${installtype}": }
  -> class { 'drupal::configure': }
  -> anchor { 'drupal::end': }

  # TODO: figure out how drush handles multisite for update. Perhaps this should go in the site define
  if $update {
    exec { 'update drupal core and all plugins':
      command => "drush up",
      path    => '/usr/local/bin:/bin:/usr/bin',
      require => Class['drupal::configure'],
    }
  }
}
