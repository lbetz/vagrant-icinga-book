class role::monitor::master {
  include ::profile::base
  include ::profile::ldap::client
  include ::profile::puppet::agent
}

class role::monitor::satellite {
  include ::profile::base
  include ::profile::puppet::agent
}
