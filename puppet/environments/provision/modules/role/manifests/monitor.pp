class role::monitor::master {
  include ::profile::base
  include ::profile::puppet::agent
  include ::profile::ldap::client
  include ::profile::icinga2
}

class role::monitor::satellite {
  include ::profile::base
  include ::profile::puppet::agent
}
