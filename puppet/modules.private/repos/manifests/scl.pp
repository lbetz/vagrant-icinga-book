class repos::scl {

  case $::operatingsystem {
    'centos': {
      package { 'centos-release-scl': }
    }

    default: {
      fail('Your plattform is not supported.')
    }
  }

}
