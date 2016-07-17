class nscp::params {

  case $::kernel {
    'windows': {
      $package = 'nscp'
      $service = 'nscp'
    }

    default: {
      fail("Your operatingsystem ${::operatingsystem} is not supported, yet.")
    }
  }

}
