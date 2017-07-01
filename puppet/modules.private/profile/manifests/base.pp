class profile::base {
  stage { 'first': } -> stage { 'repos': } -> Stage['main']

  case $::kernel {
    'windows': {
    }

    default: {
      class { '::ntp':
        stage   => 'first',
        require => Class[::network],
      }

      class { ['::repos::epel']:
        stage => 'repos',
      }
    }
  }

  class { '::network':
    stage => 'first',
  }
}
