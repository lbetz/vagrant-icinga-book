class profile::icinga2::agent(
  $ca_host,
  $endpoints,
  $zones,
) {


  class { 'icinga2':
    features => ['mainlog'],
    confd    => false,
  }

  # Feature: api
  class { 'icinga2::feature::api':
    pki             => 'icinga2',
    ca_host         => $ca_host,
    ticket_salt     => 'bd051f11074e2388980481ce0dbd3d76',
    accept_config   => true,
    accept_commands => true,
    endpoints       => $endpoints,
    zones           => $zones,
  }

  # global zones
  case $::osfamily {
    'windows': {
      class { '::nscp':
        notify => Class['icinga2'],
      }
      icinga2::object::zone { 'windows-commands':
        global => true,
      }
    } # windows
    default: {
      include ::profile::repo::icinga
      include ::profile::icinga2::plugins::monitoring

      icinga2::object::zone { 'linux-commands':
        global => true,
      }
    } # default
  } # case
}
