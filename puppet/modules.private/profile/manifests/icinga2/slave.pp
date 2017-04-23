class profile::icinga2::slave(
  $zone_name,
  $endpoints,
  $zones,
) {
  include profile::icinga2::base
  include profile::icinga2::pki
  include profile::icinga2::plugins::extra
  include profile::icinga2::sshkey

  class { 'icinga2':
    manage_repo => true,
    confd       => false,
    features    => ['checker','mainlog'],
    constants => {
      'ZoneName' => $zone_name,
    },
  }

  # Feature: api
  class { 'icinga2::feature::api':
    pki             => 'none',
    accept_config   => true,
    accept_commands => true,
    endpoints       => $endpoints,
    zones           => $zones,
  }

  icinga2::object::zone { ['global-templates', 'windows-commands', 'linux-commands']:
    global => true,
  }
}
