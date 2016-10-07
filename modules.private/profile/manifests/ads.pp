class profile::ads {
  include profile::base

  class { 'nscp':
    ensure => stopped,
    enable => false,
  }
}
