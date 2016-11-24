class role::proxy::extern {
  include profile::base
  include profile::puppet::agent
  include profile::squid::extern
}

class role::proxy::intern {
  include profile::base
  include profile::puppet::agent
  include profile::squid::intern
}
