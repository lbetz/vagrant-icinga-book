class nscp::service inherits nscp::params {

  $ensure = $nscp::ensure
  $enable = $nscp::enable

  service { $service:
    ensure => $ensure,
    enable => $enable,
  }

}
