class profile::base {
  stage { 'first': } -> stage { 'repos': } -> Stage['main']

  class { 'ntp':
    stage => 'first',
  } ->

  class { 'network':
    stage => 'first',
  }

  class { 'repos::icinga':
    stage => 'repos',
  }

}
