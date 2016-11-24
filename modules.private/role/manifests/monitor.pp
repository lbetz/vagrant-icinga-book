class role::monitor::master {
  include profile::base
  include profile::puppet::agent
  include profile::ldap::client
}

class role::monitor::satellite {
  include profile::base
  include profile::puppet::agent
}
