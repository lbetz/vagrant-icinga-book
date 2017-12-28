class profile::icinga2::api(
  $confd = lookup('profile::icinga2::confd'),
) {
  class { '::icinga2::feature::api':
    pki => 'none',
  }

  include ::icinga2::pki::ca

  ::icinga2::object::apiuser { 'icingaweb2':
    ensure      => present,
    password    => '12e2ef553068b519',
    permissions => [ 'status/query', 'actions/*', 'objects/modify/*', 'objects/query/*' ],
    target      => "${confd}/api-users.conf",
  }
} 
