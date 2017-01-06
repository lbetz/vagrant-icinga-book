class drupal::package::package {
  
  package { $drupal::packagename:
    ensure => $drupal::update ? {
      true  => 'latest',
      false => 'present',
    },
  }

}
