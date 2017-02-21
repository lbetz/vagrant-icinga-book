class role::gateway {
  include ::profile::base
  include ::profile::puppet::agent
  include ::profile::router
  include ::dnsmasq
}
