class drupal::params {
  # Parameters:
  # $installroot: This is simply the root of the package installed instance.
  #               We calculate it so that if the user wants a manually
  #               installed instance, we can symlink as needed
  #     $docroot: This is the standard docroot.
  #               We will either install Drupal here or provide a
  #               symlink to the installroot of the package
  case $::osfamily {
    'redhat': {
      $packagename = 'drupal7'
      $installroot = '/usr/share/drupal7'
      $docroot     = '/var/www/html/drupal'
      $apacheuser  = 'apache'
    }
    'debian': {
      $packagename = 'drupal7'
      $installroot = '/etc/alternatives/drupal'
      $docroot     = '/var/www/drupal'
      $apacheuser  = 'www-data'
    }
    default: { fail("drupal::params: osfamily ${::osfamily} not supported.") }
  }

  # The version of Drupal to install. Only used with remote installtype.
  $drupalversion   = '7.x'

  # The version of drush to install. Currently, no native packages exist.
  $drushversion    = '7.x-5.8'

  # Update drupal core, modules, themes, and perform all pending updates on each agent run.
  $update          = false

  # Allow the apache user write access to update modules and themes?
  $writeaccess     = false

  # default to installing the package from the repos
  $installtype     = 'package'

  # default to requiring the user to manage the database and the vhost
  $managedatabase  = false
  $managevhost     = false

  $database        = 'drupal'
  $dbuser          = 'drupal'
  $dbpassword      = 'drupal'
  $dbhost          = 'localhost'
  $dbport          = ''
  $dbdriver        = 'mysql'
  $dbprefix        = ''
}