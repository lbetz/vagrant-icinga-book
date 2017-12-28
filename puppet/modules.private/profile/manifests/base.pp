class profile::base {

  case $::kernel {

    'windows': {
    }

    default: {
      class { '::ntp':
        stage   => 'first',
        require => Class[::network],
      }
    }

  } # case

  class { '::network':
    stage => 'first',
  }
}
