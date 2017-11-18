class profile::icinga2::agent(
  $endpoints,
  $zones,
) {

  include ::profile::icinga2::plugins::monitoring

  class { 'icinga2':
    features    => ['mainlog'],
  }

  # Feature: api
  class { 'icinga2::feature::api':
    pki             => 'icinga2',
    ca_host         => '172.16.1.11',
    ticket_salt     => 'bd051f11074e2388980481ce0dbd3d76',
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
