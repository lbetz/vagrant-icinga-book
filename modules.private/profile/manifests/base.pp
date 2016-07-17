class profile::base {
  stage { 'first': } -> stage { 'repos': } -> Stage['main']

  case $::kernel {
    'windows': {
    }

    default: {
      class { 'ntp':
        stage => 'first',
      } ->

      class { 'repos::icinga':
        stage => 'repos',
      }
    }
  }

  class { 'network':
    stage => 'first',
  }

}
