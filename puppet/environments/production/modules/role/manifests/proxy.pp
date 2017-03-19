class role::proxy::extern {
  include ::profile::base
  include ::profile::squid::extern
  include ::profile::icinga2::base
}

class role::proxy::intern {
  include ::profile::base
  include ::profile::squid::intern
  include ::profile::icinga2::base
}
