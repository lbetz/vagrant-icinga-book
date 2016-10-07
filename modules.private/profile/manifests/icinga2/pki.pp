class profile::icinga2::pki(
  $certname = $::fqdn
) {
  case $::osfamily {
    'windows': {
      File {
        owner              => 'Administrators',
        group              => 'NETWORK SERVICE',
        source_permissions => 'ignore',
      }
      $key_file_mode = '0770'
      $pkidir = 'C:/ProgramData/icinga2/etc/icinga2/pki'
    } # windows
    default: {
      File {
        owner => 'icinga',
        group => 'icinga'
      }
      $key_file_mode = '0600'
      $pkidir = '/etc/icinga2/pki'
    } # default
  }

  file { "${pkidir}/${certname}.key":
    ensure => file,
    mode   => $key_file_mode,
    source => "puppet:///modules/profile/private_keys/${certname}.key",
    tag    => 'icinga2::config::file',
  }

  file { "${pkidir}/${certname}.crt":
    ensure => file,
    source => "puppet:///modules/profile/certs/${certname}.crt",
    tag    => 'icinga2::config::file',
  }

  file { "${pkidir}/ca.crt":
    ensure => file,
    source => 'puppet:///modules/profile/ca/ca.crt',
    tag    => 'icinga2::config::file',
  }
}
