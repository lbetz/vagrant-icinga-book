class profile::ads {
  include profile::base

  class { 'nscp':
    ensure => running,
    enable => false,
  }
}
