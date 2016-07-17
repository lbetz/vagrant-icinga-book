class nscp::install inherits nscp::params {

  package { $package:
    ensure => installed,
  }

}
