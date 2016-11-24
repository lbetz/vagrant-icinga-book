class role::monitor::master {
  include profile::base
  include profile::ldap::client
  include profile::icinga2::master
  include profile::icinga2::classicui
  include profile::icinga2::icingaweb2
}

class role::monitor::satellite {
  include profile::base
  include profile::icinga2::slave
}
