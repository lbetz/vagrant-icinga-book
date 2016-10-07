class role::gateway {
  include profile::base
  include profile::router
  include dnsmasq
}
