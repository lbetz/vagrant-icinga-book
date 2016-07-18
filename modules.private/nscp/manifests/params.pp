class nscp::params {

  case $::kernel {
    'windows': {
      $package = 'nscp'
      $service = 'nscp'
      $config  = 'C:/Program Files/NSClient++/nsclient.ini'
    }

    default: {
      fail("Your operatingsystem ${::operatingsystem} is not supported, yet.")
    }
  }

}
