class role::proxy::extern {
  include profile::base
  include profile::squid::extern
}

class role::proxy::intern {
  include profile::base
  include profile::squid::intern
}
