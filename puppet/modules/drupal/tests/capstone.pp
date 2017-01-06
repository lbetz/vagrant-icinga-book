  class { 'drupal':
    database       => 'drups',
    dbuser         => 'dbuser',
    dbpassword     => 'thuperthecret',
    dbdriver       => 'sqlite',
  }

  drupal::site { 'mysite.example.com':
    admin_password => 'derple',
  }
  $mysite_mods = prefix([ 'date', 'token', 'pathauto' ], 'mysite.example.com::')
  drupal_module { $mysite_mods:
    ensure => present,
  }

  drupal::site { 'another.example.com':
    admin_password => 'whoopsie',
  }
  $another_mods = prefix([ 'rules', 'token', 'link' ], 'another.example.com::')
  drupal_module { $another_mods:
    ensure => present,
  }
