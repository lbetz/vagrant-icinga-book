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

  # global zones and additional plugins
  case $::osfamily {
    'windows': {
      file { 'C:/ProgramData/icinga2/etc/icinga2/scripts/check_time.vbs':
        ensure             => file,
        source_permissions => ignore,
        source             => 'puppet:///modules/profile/icinga2/scripts/check_time.vbs',
        require            => Class['icinga2'],
      }
      icinga2::object::zone { 'windows-commands':
        global => true,
      }
    } # windows
    default: {
      include profile::nagios::plugins
      icinga2::object::zone { 'linux-commands':
        global => true,
      }
    } # default
  } # case
}
