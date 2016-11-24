class profile::icinga2::agent(
  $endpoints,
  $zones,
) {
  include profile::icinga2::base
  include profile::icinga2::pki

  class { 'icinga2':
    confd     => false,
    features  => ['checker','mainlog'],
  }

  # Feature: api
  class { 'icinga2::feature::api':
    pki             => 'none',
    accept_config   => true,
    accept_commands => true,
    endpoints       => $endpoints,
    zones           => $zones,
  }

  # global zones
  case $::osfamily {
    'windows': {
      icinga2::object::zone { 'windows-commands':
        global => true,
      }
    } # windows
    default: {
      icinga2::object::zone { 'linux-commands':
        global => true,
      }
    } # default
  } # case
}
