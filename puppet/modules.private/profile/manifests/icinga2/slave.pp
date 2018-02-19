class profile::icinga2::slave(
  $zone_name,
  $endpoints,
  $zones,
) {

  include ::profile::repo::icinga
  include ::profile::icinga2::plugins::monitoring

  class { 'icinga2':
    confd       => false,
    features    => ['checker','mainlog'],
    constants => {
      'ZoneName' => $zone_name,
    },
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

  icinga2::object::zone { ['global-templates', 'windows-commands', 'linux-commands']:
    global => true,
  }
}
