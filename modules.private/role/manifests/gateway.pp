class role::gateway {
  include profile::base
  include profile::router
  include profile::icinga2::agent
  include dnsmasq
}
