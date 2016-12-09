class profile::base {
  stage { 'first': } -> stage { 'repos': } -> Stage['main']

  case $::kernel {
    'windows': {
    }

    default: {
      class { 'ntp':
        stage => 'first',
      }

      include vim

      class { ['repos::icinga', 'repos::plugins', 'repos::elastic']:
        stage => 'repos',
      }
    }
  }

  class { 'network':
    stage => 'first',
  }

  host { 'logstash01':
    ensure => 'present',
    ip     => '192.168.56.23',
  }

}
